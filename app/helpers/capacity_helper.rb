module CapacityHelper
  def getTodaysCapacity(institution_id = nil)
    id = (institution_id.present?) ? institution_id : @institution.id
  end
end
