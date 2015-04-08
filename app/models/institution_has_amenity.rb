class InstitutionHasAmenity < ActiveRecord::Base
	belongs_to :institution 
	belongs_to :amenity
end
