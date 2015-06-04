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
    number = params[:From][2..-1]
    Rails.logger.info "Received from: " + params[:From]
    Rails.logger.info "Message: " + message
    if message.downcase.starts_with?("unsubscribe")
      unsubscribe(number)
    elsif message.downcase.starts_with?("subscribe")
      institutions = messages.scan(/\d+/)
      subscribe_to_institutions(number, institutions)
    elsif message.downcase.starts_with?("near me")
      zip = params[:FromZip]
      locations = Location.where(zip: zip)
      locations.each do |l|
        puts "near me -> " + l.to_json
      end
    elsif message.downcase.match(/near \d{5}/)
      zip = message.downcase.scan(/\d{5}/)
      puts zip
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

  def unsubscribe(number)
    begin
      numbers = Subscriber.where(phone: number)
      Rails.logger.info "Removing number: #{number} from subscriptions\n" + numbers.pluck(:institution_id).join(" ")
      numbers.destroy_all()
      send_message(number, "You have unsubscribed from #{numbers.length} #{"institution".pluralize(numbers.length)}")
    rescue => e
      puts e
    end
  end

  private
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
          @client.account.messages.create({
            :from => Settings.twilio.number,
            :to => num,
            :body => message
          })
        rescue Twilio::REST::RequestError => e
          puts e.message
        end
      end
    end

    def subscribe_to_institutions(number, institutions)
      message = []
      instructions.each do |num|
        if Institution.where(id: num).nil?
          message << "Institution #{num} doesn't exist. Can't subscribe."
        else
          subscriber = Subscriber.where({phone: number, institution_id: num})
          name = Institution.find(id).name
          if subscriber.present?
            message = t('sms.subscribe.existing', name: name)
          else
            if Subscriber.create(phone: number, institution_id: id)
              message = t('sms.subscribe.success', name: name)
            end
          end
        end
      end
      send_message(number, message.join("\n"))
    end
end
