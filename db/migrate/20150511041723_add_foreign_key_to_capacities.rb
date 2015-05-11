class AddForeignKeyToCapacities < ActiveRecord::Migration
  def change
  	 add_column :capacities, :institution_id, :integer  
  	 remove_column :capacities, :reserved_confirmed
  end
end
