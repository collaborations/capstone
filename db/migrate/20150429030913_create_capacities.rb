class CreateCapacities < ActiveRecord::Migration
  def change
    create_table :capacities do |t|
		t.integer :shelter_id 
		t.integer :num_reserved
		t.integer :num_standby
    	t.timestamps null: false
    end
  end
end
