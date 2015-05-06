class CapacityController < ApplicationController
  # Introducing this has to give some sort of CSRF vulnerability
  skip_before_action :verify_authenticity_token

  def index
  end

  def get
    puts params
    id = 1
    # Should get total from the institution as the maximum number of spots allowed
    total = 50
    # Will want to change this to return the data for the current date.
    data = Capacity.where(id: id).first
    render json: [
                  {
                    type: "reserved",
                    value: data.reserved
                  },
                  {
                    type: "reserved_confirmed",
                    value: data.reserved_confirmed
                  },
                  {
                    type: "standby",
                    value: data.standby
                  }
                ]
  end

  def update
  end
  
end
