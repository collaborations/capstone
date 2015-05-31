module InstitutionsHelper

  def getAmenities(institution_id)
    return Institution.where(id: institution_id).first.amenities
  end

  def getContactInfo(institution_id)
    contact = Contact.where(institution_id: institution_id)
    return contact.first if contact.present?
  end

  def getDirectionsLink(location)
    address = location.streetLine1 + " "
    address << location.streetLine2 + " " if location.streetLine2.present?
    address << location.city + ", " + location.state + " " + location.zip.to_s
    "https://www.google.com/maps/place/" + address.sub(/\s/, "+")
  end

	def getDistance(institution_id)
		rand(0..100)
	end

  # Use parameter if provided, otherwise use instance variable.
  # 
  # Any individual institution pages can use the instance variable, however if
  # there is a loop over multiple institutions (institutions#list), it needs to
  # be provided.
	def getHours(institution_id = nil)
    id = (institution_id.present?) ? institution_id : @institution.id
  	temp = Hours.where(institution_id: id).first
    if temp.present?
      return temp
    else
      return [t('hours.missing')]
    end
	end

  def getPhone(institution_id)
    contact = Contact.where(institution_id: institution_id)
    if contact.present? and contact.first.phone.present?
      phone = contact.first.phone.split("-")
      return sprintf("(%s)%s-%s", phone[0], phone[1], phone[2])
    else
      return t('contact.phone.missing')
    end
  end

  def getWebsite(institution_id)
    contact = Contact.where(institution_id: institution_id).first
    if contact.present?
      if contact.website.present?
        return full_url contact.website
      end
    end

    return t('contact.website.missing')
  end

end
