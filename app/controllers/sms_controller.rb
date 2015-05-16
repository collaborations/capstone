class SmsController < ApplicationController
  # before_action :authenticate_user!, only: [:index, :mass_text]

  def index
    # @institution = current_user.institution_id
    # @subscribers = Subscriber.find(institution_id: current_user.institution_id)
    
  end

  def retrieve_messages
  end

  def mass_text
    message = params.require(:message)
    @subscribers ||= Subscriber.find(institution_id: current_user.institution_id)
    send_message(@subscribers, message)
  end

  def send_info
    number = params.require(:number)
    body = params.require(:body)

    send_message([number], body)
  end

  # GET /institution/:id/subscribe
  def subscribe(number, institution_id)
    begin
      subscriber = Subscriber.find(phone: number, institution_id: institution_id)
      if subscriber.present?
        flash[:error] = "Already Subscribed"
      elsif !number.match(/\d{10}/).present?
        flash[:error] = "Bad Number"
      else
        Subscriber.create(phone: number, institution_id: institution_id)
      end
    rescue => e
      puts e
    end
  end

  def unsubscribe(number, institution_id)
    begin
      subscriber = Subscriber.find(phone: number, institution_id: institution_id)
      if subscriber.empty?
        flash[:error] = "Subscriber not registered"
      elsif !number.match(/\d{10}/).present?
        flash[:error] = "Bad Number"
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
