class SmsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :notify]
  before_action :check_subscribers, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:reply]
  include HoursHelper

  def index
  end

  # This should notify all subscribers by sending them a message.
  def notify
    id = current_user.institution_id
    @subscribers ||= Subscriber.where(institution_id: id)
    send_message(@subscribers.map(&:phone), params[:message]) if params[:message].present?
    head :ok, content_type: "text/html"
  end

  # This is hit by Twilio every time we receive a text
  def reply
    Rails.logger.info params

    message = params[:Body]
    phone = params[:From][2..-1]

    if message.downcase.starts_with?("remove")
      # Remove
      unsubscribe(phone)
    elsif message.downcase.starts_with?("add")
      # Add [id]
      institutions = message.scan(/\d+/)
      subscribe_to_institutions(phone, institutions)
    elsif message.downcase.starts_with?("near me") or message.downcase.starts_with?("nearby")
      # Near me | Nearby
      zip = params[:FromZip]
      m = nearZip(zip)
      send_message([phone], m)
    elsif message.downcase.starts_with?("near")
      # Near [zipcode]
      zips = message.downcase.scan(/\d{5}/)
      zips.each do |zip|
        m = nearZip(zip)
        send_message([phone], m)
      end
    elsif message.downcase.starts_with?("capacity")
      # Capacity [id]
      id = message.downcase.scan(/\d+/)
      if id.present?
        m = capacity(id)
      else
        m = "It appears you're missing an id. Example: 'capacity 10'"
      end
      send_message([phone], m)
    else
      m = []
      m << "Unfortunately I don't understand how to process: "
      m << message + "\n\n"
      m << "I understand the following:"
      m << "nearby | near me - Shows locations within your zipcode"
      m << "near [zipcode] - Shows locations within the given zipcode"
      m << "capacity [id] - Shows the current capacity of the given institution"
      m << "add [id] - Subscribes to the institution with that ID"
      m << "remove - Removes you from all subscriptions"
      send_message([phone], m.join("\n\n"))
    end
    head :ok, content_type: "text/html"
  end

  def info
    begin
      id = params.require(:institution_id)
      number = params.require(:sms)
      institution = Institution.where(id: id).first
      message = [institution.name]

      if params[:phone].present?
        contact = Contact.where(institution_id: id)
        if contact.present? and contact.first.phone.present?
          phone = contact.first.phone.split("-")
          message << sprintf("\nPhone: (%s)%s-%s", phone[0], phone[1], phone[2])
        end
      end

      if params[:hours].present?
        days = Date::DAYNAMES
        hours = getHours(id)
        message << "\nHours"
        hours.each_with_index do |h, i|
          message << "#{days[i]} - #{h}"
        end
      end

      if params[:address].present?
        address = Location.where(institution_id: id)
        address = address.first if address.present?
        message << "\nAddress:"
        message << address.streetLine1
        message << address.streetLine2 if address.streetLine2.present?
        message << sprintf("%s, %s %s", address.city, address.state, address.zip)
      end

      if params[:amenities].present?
        amenities = InstitutionHasAmenity.joins(:amenity, :institution).where(institution_id: id).map(&:amenity)
        message << "\nAmenity".pluralize(amenities.size) + ":" if amenities.present?
        amenities.each do |a|
          message << "- " + a.name.capitalize
        end
      end

      if params[:restrictions].present?
        message << "\nRestrictions"
        message << institution.instructions
      end

      send_message([number], message.join("\n"))
    rescue ActionController::ParameterMissing => e
      puts e.message
      head :bad_request, content_type: "text/html"
    end
    head :ok, content_type: "text/html"
    
  end

  # POST /institution/subscribe
  # TODO: Intergrate this with subscribe_to_institutions. I didn't want to do it so close to Capstone presentations.
  def subscribe
    begin
      # Get phone number
      number = params.require(:number)
      id = params.require(:id)
      # Check if phone number exists in database for given institution
      subscriber = Subscriber.where({phone: number, institution_id: id})
      name = Institution.find(id).name
      if subscriber.present?
        message = t('sms.subscribe.existing', name: name)
      else
        if Subscriber.create(phone: number, institution_id: id)
          message = t('sms.subscribe.success', name: name)
        end
      end
      redirect_to '/institution/' + id.to_s
    rescue => e
      puts e
    end
    if message.present?
      send_message([number], message)
    end
  end

  def unsubscribe(phone)
    begin
      numbers = Subscriber.where(phone: phone)
      Rails.logger.info "Removing number: #{phone} from subscriptions\n" + numbers.pluck(:institution_id).join(" ")
      total = numbers.length
      numbers.destroy_all()
      send_message([phone], "You have unsubscribed from #{total} #{"institution".pluralize(total)}")
    rescue => e
      puts e
    end
  end

  private
    def capacity(id)
      message = []
      capacity = Capacity.where("institution_id = ? AND created_at >= ?", id, Time.zone.now.beginning_of_day).first
      if capacity.present?
        message << "Taken: #{capacity.reserved + capacity.standby}"
        message << "Available: #{capacity.available}"
        message << "Last updated at #{capacity.updated_at.strftime("%l:%M %p")}"
      else
        institution = Institution.where(id: id).first
        if institution.present?
          message << "No capacity logged today for #{institution.name}"
        else
          message << "Could not find institution with id #{id}"
        end
      end
      return message.join("\n")
    end

    def check_subscribers
      @subscribers = Subscriber.where(institution_id: current_user.institution_id)
      if @subscribers.length == 0
        flash[:warning] = t('sms.subscribe.empty')
      end
    end


    def send_message(numbers, message)
      @client = Twilio::REST::Client.new Settings.twilio.sid, Settings.twilio.auth
      numbers.each do |num|
        begin
          if message.length > 1000
            m = message[0...1000]
            @client.account.messages.create({
              :from => Settings.twilio.number,
              :to => num,
              :body => message
            })
          else
            @client.account.messages.create({
              :from => Settings.twilio.number,
              :to => num,
              :body => message
            })
          end
        rescue Twilio::REST::RequestError => e
          puts e.message
        end
      end
    end

    def subscribe_to_institutions(phone, institutions)
      message = ""
      institutions.each do |id|
        if Institution.where(id: id).nil?
          message << "Institution #{id} doesn't exist. Can't subscribe."
        else
          subscriber = Subscriber.where({phone: phone, institution_id: id})
          name = Institution.find(id).name
          if subscriber.present?
            message = t('sms.subscribe.existing', name: name)
          else
            if Subscriber.create(phone: phone, institution_id: id)
              message = t('sms.subscribe.success', name: name)
            end
          end
        end
      end
      send_message([phone], message)
    end

    def nearZip(zip)
      locations = Location.where(zip: zip)
      if locations.present?
        message = ["Locations near zip: #{zip}"]
        locations.each do |l|
          institution = Institution.where(id: l.institution_id).first
          if institution.present?
            message << "\n" + institution.name
            if l.streetLine1.present?
              message << l.streetLine1
            end
            if l.streetLine2.present?
              message << l.streetLine2
            end
            if l.city.present? and l.state.present? and l.zip.present?
              message << l.city + ", " + l.state + " " + l.zip
            end
          end
        end
      else
        message = ["Could not find any locations for #{zip}"]
      end
      Rails.logger.info message.join("\n")
      return message.join("\n")
    end
end
