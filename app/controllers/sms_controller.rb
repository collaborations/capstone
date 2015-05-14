class SmsController < ApplicationController
  def notify
    puts params
    render text: "Implement Sending SMS"
  end
  
  def retrieve_messages(params)
  end

  def send_message(params)
    message = params.require(:message)
    numbers = params.require(:numbers)

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

end
