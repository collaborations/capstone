module InstitutionsHelper

  def getAmenities
    return Institution.where(id: @institution.id).first.amenities
  end
  
  def getDirectionsLink(location)
    address = location.streetLine1 + " "
    address << location.streetLine2 + " " if location.streetLine2.present?
    address << location.city + ", " + location.state + " " + location.zip.to_s
    "https://www.google.com/maps?saddr=Current+Location&daddr="+address.sub(/\s/, "+")

  end

end
