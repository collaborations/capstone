class CapacityController < ApplicationController
  # Introducing this has to give some sort of CSRF vulnerability
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!, only: [:index, :update]
  before_action :set_institution_id, only: [:index, :update]
  before_action :set_capacity, only: [:index, :update]
  before_action :set_total_capacity, only: [:index, :update]

  def index
    @institution = Institution.find(@id)
    @max = @total
    gon.push({
      :capacity => @total
    })
  end

  def get
    if params[:id].present?
      @id = params[:id]
      set_capacity()
      set_total_capacity()
    elsif user_signed_in?
      set_institution_id()
    end
    render json: get_data
  end

  def getByID
    if params[:capacity_ids].present?
      allData = []
      ids = params[:capacity_ids]
      ids.each do |cap|
        data = get_data(cap, true)
        if data.present?
          allData << { id: cap, data: data }
        end
      end
      render json: allData
    else
      head :bad_request
    end
  end

  def update
    @capacity.update(
      available: params[:available],
      reserved: params[:reserved],
      standby: params[:standby]
    )
    render json: get_data
  end

  private
    def get_data(id = @id, last_update = false)
      @data = []
      capacity = Capacity.where("institution_id = ? AND created_at >= ?", id, Time.zone.now.beginning_of_day).first
      if capacity.present?
        @data << { type: "reserved", value: capacity.reserved }
        @data << { type: "standby", value: capacity.standby }
        @data << { type: "available", value: capacity.available }
        if last_update
          @data << { type: "last_update", value: capacity.updated_at.strftime("%l:%M %p") }
        end
      end
      @data
    end

    def set_institution_id
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
