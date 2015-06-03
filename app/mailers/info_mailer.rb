class InfoMailer < ApplicationMailer
  add_template_helper(HoursHelper)
  def new(institution_id, email, options)
    @institution = Institution.find(institution_id)

    if options[:phone].present?
      @contact = Contact.where(institution_id: institution_id)
      if @contact.present? and @contact.first.phone.present?
        @phone = @contact.first.phone.split("-")
      end
    end

    if options[:hours].present?
      @hours = true
    end

    if options[:address].present?
      address = Location.where(institution_id: institution_id)
      @address = address.first if address.present?
    end

    if options[:amenities].present?
      @amenities = InstitutionHasAmenity.joins(:amenity, :institution).where(institution_id: institution_id).map(&:amenity)
    end

    if options[:restrictions].present?
      temp = @restrictions.present?
      @restrictions = temp.present? ? @institution.instructions : "No restrictions"
    end

    mail(to: email, subject: "Information For #{@institution.name}")
  end
end
