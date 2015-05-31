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
  # 
  # This is absolutely terrible code, but it works for right now.
	def getHours(institution_id = nil)
    id = (institution_id.present?) ? institution_id : @institution.id
    time_format = t('hours.time.format')

  	h = Hours.where(institution_id: id).first
    hours = []

    temp = [ 
              [ "Monday", h[:mon_open], h[:mon_close]],
              [ "Tuesday", h[:tue_open], h[:tue_close]],
              [ "Wednesday", h[:wed_open], h[:wed_close]],
              [ "Thursday", h[:thu_open], h[:thu_close]],
              [ "Friday", h[:fri_open], h[:fri_close]],
              [ "Saturday", h[:sat_open], h[:sat_close]],
              [ "Sunday", h[:sun_open], h[:sun_close]]
           ]
    
    temp.each do |t|
      open = t[1].present? ? t[1].strftime(time_format) : nil
      close = t[2].present? ? t[2].strftime(time_format) : nil
      if open.present? and close.present?
        hours << { day: t[0], hours: open + "-" + close}
      else
        hours << { day: t[0] }
      end
    end

    # Whether the institution is current open
    c_time = Time.now
    h_today = temp[c_time.wday]
    BusinessTime::Config.beginning_of_workday = h_today[1].to_s
    BusinessTime::Config.end_of_workday = h_today[2].to_s
    open = c_time.during_business_hours?


    render 'shared/hours', hours: hours, open: open
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
