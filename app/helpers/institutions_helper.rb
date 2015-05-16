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
		details = InstitutionDetail.where(institution_id: institution_id)
    if details.present? and details.first.hours.present?
      return details.first.hours
    else
      return "Not Listed"
    end
	end

  def getPhone(institution_id)
    contact = Contact.where(institution_id: institution_id)
    if contact.present? and contact.first.phone.present?
      phone = contact.first.phone.split("-")
      return sprintf("(%s)%s-%s", phone[0], phone[1], phone[2])
    else
      return "Not Listed"
    end
  end

  def getWebsite(institution_id)
    contact = Contact.where(institution_id: institution_id)
    if contact.present? and contact.first.website.present?
      return contact.first.website
    else
      return "Not Listed"
    end
  end

end
