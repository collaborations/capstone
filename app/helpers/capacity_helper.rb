module CapacityHelper
  def getTodaysCapacity(institution_id = nil)
    id = (institution_id.present?) ? institution_id : @institution.id
    Capacity.where("institution_id = #{id} ORDER BY created_at")
  end
end
