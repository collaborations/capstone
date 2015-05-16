class CapacityController < ApplicationController
  # Introducing this has to give some sort of CSRF vulnerability
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:update, :index]

  def index
    @total = InstitutionDetail.where(institution_id: current_user.institution_id).first.capacity
    if @total == 0
      @max_capacity_prompt = true
    end

    gon.push({
      :capacity => @total
    })
  end

  def get
    # ID should be passed in as a parameter and be the id of the institution
    if params[:id].present?
      id = params[:id]
    else 
      id = current_user.institution_id
    end

    # Should get total from the institution as the maximum number of spots allowed
    total = InstitutionDetail.where(institution_id: id).first.capacity
    
    @data = Capacity.where("institution = ? AND created_at >= ?", id, Time.zone.now.beginning_of_day)
    if @data.present?
      @data = @data.first
    else
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
    id = current_user.institution_id
    total = InstitutionDetail.where(institution_id: id).first.capacity
    @data = Capacity.where("institution = ? AND created_at >= ?", id, Time.zone.now.beginning_of_day).first

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
