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
    #   message = params.require(:message)
    #   send_message(@subscribers, message)
    #   puts @subscribers
    # end
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
    # number = params.require(:number)
    begin
      # Get phone number
      number = params.require(:number)
      id = params.require(:id)
      # Check if phone number exists in database for given institution
      subscriber = Subscriber.where({phone: number, institution_id: id})
      puts "Subscriber"
      puts subscriber
      puts "ID"
      puts id.to_s
      puts "Phone Number"
      puts number.to_s
      if subscriber.present?
        puts "Found"
        flash[:notice] = "Already Subscribed"
      else
        puts "Not found"
        Subscriber.create(phone: number, institution_id: id)
      end
      render 'show'

      # If number exists
        # Fail and show message
      # Else
        # Create object and send confirmation message



      
    
      # subscriber = Subscriber.new({phone: number, institution_id: institution_id})
      # # subscriber = Subscriber.find(phone: number, institution_id: institution_id) 
      # if subscriber.present?
      #   flash[:error] = "Already Subscribed"
      # elsif !number.match(/\d{10}/).present?
      #   flash[:error] = "Bad Number"
      # else
      #   Subscriber.create(phone: number, institution_id: institution_id)
      # end

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
