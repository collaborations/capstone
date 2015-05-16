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
    puts params
    head :ok, content_type: "text/html"
    # send_message([number], body)
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
