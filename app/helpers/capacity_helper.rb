module CapacityHelper
  def getTotalCapacity(institution_id = nil)
    id = (institution_id.present?) ? institution_id : @institution.id
    details = InstitutionDetail.where(institution_id: id).first
    if details.present? and details.capacity.present?
      return details.capacity
    end
  end
end
