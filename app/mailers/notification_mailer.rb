class NotificationMailer < ApplicationMailer

  def institution_details(id, email, options)
    begin
      @institution = Institution.where(id: id).first
      
      if options[:phone].to_bool
        contact = Contact.where(institution_id: id)
        if contact.present? and contact.first.phone.present?
          phone = contact.first.phone.split("-")
          @phone = sprintf("Phone: (%s)%s-%s", phone[0], phone[1], phone[2])
        end
      end

      if options[:hours].to_bool
        # details = InstitutionDetails.where(institution_id: id)
        # details = details.first if details.present? and details.hours.present?
        @hours = "Hours: MF"
      end

      if options[:address].to_bool
        address = Location.where(institution_id: id)
        @address = address.first if address.present?
      end

      if options[:amenities].to_bool
        @amenities = InstitutionHasAmenity.joins(:amenity, :institution).where(institution_id: id).map(&:amenity)
      end

      if options[:restrictions].to_bool
        @restrictions = Restrictions.where(institution_id: id)
      end
    rescue ActionController::ParameterMissing => e
      puts e.message
    end
    mail(to: email, subject: 'Information from Step Stone')
  end

  def welcome_email(user)
    mail(to: user.email, subject: 'Welcome to Step Stone!')
  end
end
