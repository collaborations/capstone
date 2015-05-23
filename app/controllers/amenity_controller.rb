class AmenityController < ApplicationController
  def getAmenitiesByInstitution
    amenities = InstitutionHasAmenity.where(institution_id: params[:id]).map(&:amenity)
    render :json => amenities.to_json
  end
end
