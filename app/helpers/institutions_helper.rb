module InstitutionsHelper

  def getAmenities
    return Institution.where(id: @institution.id).first.amenities
  end

  def getContactInfo
    contact = Contact.where(institution_id: @institution.id)
    return contact.first if contact.present?
  end

  def getDirectionsLink(location)
    address = location.streetLine1 + " "
    address << location.streetLine2 + " " if location.streetLine2.present?
    address << location.city + ", " + location.state + " " + location.zip.to_s
    "https://www.google.com/maps/place/" + address.sub(/\s/, "+")
  end

	def getDistance
		rand(0..100)
	end

	def getHours
		# details = InstitutionDetail.where(institution_id: @institution.id)
    #   if details.present? and details.first.hours.present?
    #     return details.first.hours
    #   else
    #     return "Not Listed"
    #   end
    "Not Listed"
	end

  def getPhone
    contact = Contact.where(institution_id: @institution.id)
    if contact.present? and contact.first.phone.present?
      phone = contact.first.phone.split("-")
      return sprintf("(%s)%s-%s", phone[0], phone[1], phone[2])
    else
      return "Not Listed"
    end
  end

  def getWebsite
    contact = Contact.where(institution_id: @institution.id)
    if contact.present? and contact.first.website.present?
      contact.first.website
    end
  end

end
