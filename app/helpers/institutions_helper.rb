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

  def getPhone
    contact = Contact.where(institution_id: @institution.id)
    if contact.present? and contact.first.phone.present?
      phone = contact.first.phone.split("-")
      return sprintf("(%s)%s-%s", phone[0], phone[1], phone[2])
    else
      return t('contact.phone.missing')
    end
  end

  def getWebsite
    contact = Contact.where(institution_id: @institution.id).first
    if contact.present?
      if contact.website.present?
        return full_url contact.website
      end
    end

    return t('contact.website.missing')
  end

end
