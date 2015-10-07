module InstitutionsHelper

  def getAmenities
    return Institution.where(id: @institution.id).first.amenities
  end
  
end
