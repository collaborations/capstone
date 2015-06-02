class CapacityController < ApplicationController
  # Introducing this has to give some sort of CSRF vulnerability
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:index, :update]
  before_action :set_id, only: [:index, :update]
  before_action :set_capacity, only: [:index, :update]
  before_action :set_total_capacity, only: [:index, :update]

  def index
    gon.push({
      :capacity => @total
    })
  end

  def get
    # ID should be passed in as a parameter and be the id of the institution
    if params[:id].present?
      @id = params[:id]
    elsif user_signed_in?
      set_id()
    end
    set_capacity()
    set_total_capacity()
    render json: get_data
  end

  def update
    @capacity.update(
      reserved: params[:reserved],
      standby: params[:standby]
    )
    render json: get_data
  end

  private
    def get_data
      data = []
      data << { type: "reserved", value: @capacity.reserved }
      data << { type: "standby", value: @capacity.standby }
    end

    def set_id
      @id = current_user.institution_id
    end

    def set_total_capacity
      details = InstitutionDetail.where(institution_id: @id).first
      if details.present? and details.capacity.present?
        @total = details.capacity
      else
        flash[:warning] = "Maximum capacity has not yet been set."
        @max_capacity_prompt = true
      end
    end

    def set_capacity
      @capacity = Capacity.where("institution_id = ? AND created_at >= ?", @id, Time.zone.now.beginning_of_day).first
      if @capacity.nil?
        @capacity = Capacity.create(institution_id: @id)
      end
    end
end
