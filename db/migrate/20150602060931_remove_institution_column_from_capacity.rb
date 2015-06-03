class RemoveInstitutionColumnFromCapacity < ActiveRecord::Migration
  def change
    remove_column :capacities, :institution
    change_column :capacities, :institution_id, :integer, null: false
  end
end
