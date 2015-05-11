module InstitutionsHelper

  def getAmenities(institution_id)
    return Institution.where(id: institution_id).first.amenities
  end

  def getDirectionsLink()
    "#"
  end

	def getDistance(institution_id)
		rand(0..100)
	end

	def getHours(institution_id)
		"8:00am - 5:00pm"
	end


end
