module InstitutionsHelper

  def getAmenities(institution_id)
    return Institution.where(id: institution_id).first.amenities
  end

  def getContactInfo(institution_id)
    contact = Contact.where(institution_id: institution_id)
    return contact.first if contact.present?
  end

  def getDirectionsLink(address)
    "https://www.google.com/maps/place/" + address.sub(/\s/, "+")
  end

	def getDistance(institution_id)
		rand(0..100)
	end

	def getHours(institution_id)
		hours = InstitutionDetails.where(institution_id: institution_id)
    if hours.present?
      return hours.first
    else
      return "No Hours Listed"
    end
	end

end
