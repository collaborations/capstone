class SmsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :notify]

  def index
    # @institution = current_user.institution_id
    # @subscribers = Subscriber.find(institution_id: current_user.institution_id)
    @subscribers = ["2063713424"]
  end

  # This should notify all subscribers by sending them a message.
  def notify
    id = current_user.institution_id
    @subscribers ||= Subscriber.where(institution_id: id)
    if params[:message].present?
      send_message(@subscribers)
    end
    render 'index'
  end

  def retrieve_messages
  end

  def send_info
    number = params.require(:number)
    body = params.require(:body)

    send_message([number], body)
  end

  # POST /institution/subscribe
  def subscribe
    begin
      # Get phone number
      number = params.require(:number)
      id = params.require(:id)
      # Check if phone number exists in database for given institution
      subscriber = Subscriber.where({phone: number, institution_id: id})
      if subscriber.present?
        flash[:notice] = "Already Subscribed"
      else
        Subscriber.create(phone: number, institution_id: id)
      end
      redirect_to '/institution/' + id.to_s
    rescue => e
      puts e
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
      numbers.each do |num|
        begin
          @client = Twilio::REST::Client.new Settings.twilio.sid, Settings.twilio.auth
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

end
