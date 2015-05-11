class CapacityController < ApplicationController
  # Introducing this has to give some sort of CSRF vulnerability
  skip_before_action :verify_authenticity_token
  
  # TODO: Before adding this, we need do error handling for if someone isn't logged in.
  # before_action :authenticate_user!

  def index
  end

  def get
    # ID should be passed in as a parameter and be the id of the institution
    id = 1
    # Should get total from the institution as the maximum number of spots allowed
    total = 100
    
    @data ||= Capacity.where("institution = ? AND created_at >= ?", id, Time.zone.now.beginning_of_day).first
    if !@data.present?
      @data = Capacity.new(institution: id)
      @data.save
    end

    render json: [
                {
                  type: "reserved",
                  value: @data.reserved
                },
                {
                  type: "standby",
                  value: @data.standby
                },
                {
                  type: "empty",
                  value: total - @data.reserved - @data.standby
                }
              ]
  end

  def update
    pp params
    id = 1
    total = 100
    @data ||= Capacity.where("institution = ? AND created_at >= ?", id, Time.zone.now.beginning_of_day).first
    if !@data.present?
      @data = Capacity.new(institution: id)
      @data.save
    end
    @data.update(
      reserved: params[:reserved],
      standby: params[:standby]
    )
    render json: [
                {
                  type: "reserved",
                  value: @data.reserved
                },
                {
                  type: "standby",
                  value: @data.standby
                },
                {
                  type: "empty",
                  value: total - @data.reserved - @data.standby
                }
              ]
  end

end
