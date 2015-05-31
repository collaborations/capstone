class SmsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :notify]

  def index
    @subscribers = Subscriber.where(institution_id: current_user.institution_id)
  end

  # This should notify all subscribers by sending them a message.
  def notify
    id = current_user.institution_id
    @subscribers ||= Subscriber.where(institution_id: id)
    send_message(@subscribers.map(&:phone), params[:message]) if params[:message].present?
    head :ok, content_type: "text/html"
  end

  def retrieve_messages
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
          message << sprintf("Phone: (%s)%s-%s", phone[0], phone[1], phone[2])
        end
      end

      if params[:hours].present?
        # details = InstitutionDetails.where(institution_id: id)
        # details = details.first if details.present? and details.hours.present?
        message << "Hours: MF"
      end

      if params[:address].present?
        address = Location.where(institution_id: id)
        address = address.first if address.present?
        message << "Address:"
        message << address.streetLine1
        message << address.streetLine2 if address.streetLine2.present?
        message << sprintf("%s, %s %s", address.city, address.state, address.zip)
      end

      if params[:amenities].present?
        amenities = InstitutionHasAmenity.joins(:amenity, :institution).where(institution_id: id).map(&:amenity)
        message << "Amenity".pluralize(amenities.size) + ":" if amenities.present?
        amenities.each do |a|
          message << "- " + a.name.capitalize
        end
      end

      if params[:restrictions].present?
        message << "Restrictions"
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

  def unsubscribe(number, institution_id)
    begin
      subscriber = Subscriber.find(phone: number, institution_id: institution_id)
      if subscriber.empty?
        flash[:notice] = "Subscriber not registered"
      elsif !number.match(/\d{10}/).present?
        flash[:notice] = "Bad Number"
      else
        subscriber.destroy_all
      end
    rescue => e
      puts e
    end
  end

  private
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
        puts @client
      end
    end

end
