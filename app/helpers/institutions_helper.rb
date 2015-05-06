module InstitutionsHelper
	def getDistance(institution_id)
		30
	end

	def getHours(institution_id)
		"8:00am - 5:00pm"
	end

	def getAmenities(institution_id)
		amenities = ["Clothing", "Food", "Shelter", "Hygiene"]
		return amenities
	end

end
