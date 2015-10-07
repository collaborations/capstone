module ContactHelper

  def getContactInfo
    contact = Contact.where(institution_id: @institution.id)
    return contact.first if contact.present?
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

  def load_contact_info
    contact = Contact.where(institution_id: @institution.id)
    contact = contact.first if contact.present?
    @contact = []
    if contact.email.present?
      @contact << { label: "Email: ", info: contact.email }
    end
    if contact.phone.present?
      @contact << { label: "Phone: ", info: contact.phone }
    end
    if contact.website.present?
      @contact << { label: "Website: ", info: contact.website }
    end
  end
  
end
