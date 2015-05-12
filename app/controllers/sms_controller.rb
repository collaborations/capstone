class SmsController < ApplicationController
  def notify
    puts params
    render text: "Implement Sending SMS"
  end
  
  def subscribe
  end

  def unsubscribe
  end
end
