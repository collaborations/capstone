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
  end

  def unsubscribe(number, institution_id)
  end

end
