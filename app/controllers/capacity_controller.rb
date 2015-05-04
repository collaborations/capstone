class CapacityController < ApplicationController
  # Introducing this has to give some sort of CSRF vulnerability
  skip_before_action :verify_authenticity_token

  def index
  end

  def get
    id = 1
    # Should get total from the institution as the maximum number of spots allowed
    total = 50
    # Will want to change this to return the data for the current date.
    data = Capacity.where(id: id).first
    render json: {
        "reserved": data.reserved,
        "reserved_confirmed": data.reserved_confirmed,
        "standby": data.standby,
        "total": total
      }
  end

  def update
  end
  
end
