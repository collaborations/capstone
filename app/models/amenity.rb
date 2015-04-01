class Amenity < ActiveRecord::Base
	has_many :institution_has_amenities
	has_many :institutions, through: :institution_has_amenities
end
