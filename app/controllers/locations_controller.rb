class InstitutionsController < ApplicationController
  def set_locations
    lat = 0
    long = 0
    gon.markers = []
    institutions = @institution.present? ? [@institution] : @institutions
    institutions.each do |i|
      loc = i.locations.first
      if !loc.lat.present? or !loc.long.present?
        getLatLong(i)
        # Update data with current database values
        loc = i.locations.first
      end
      lat += loc.lat if loc.lat.present?
      long += loc.long if loc.long.present?
      gon.markers << [i.id, ActionController::Base.helpers.link_to(i.name, institution_path(i.id)), loc.lat, loc.long]
    end
    unless lat == 0 and long == 0
      gon.push({
        :latitude => lat/gon.markers.length,
        :longitude => long/gon.markers.length
      })
    end
  end
end