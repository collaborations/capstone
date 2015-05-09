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

	def getMapURL
		mode = "place"
		key = "AIzaSyBPK3tB2tAZbat9Sq3zcmTBUGCxZUO_zzg"
		parameters = "q=Space+Needle,Seattle+WA"

		"https://www.google.com/maps/embed/v1/"+mode+"?key="+key+"&"+parameters
	end

end
