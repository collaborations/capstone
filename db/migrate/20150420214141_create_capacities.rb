class CreateCapacities < ActiveRecord::Migration
  def change
    create_table :capacities do |t|
      t.integer :reserved
      t.integer :reserved_confirmed
      t.integer :standby
      t.timestamps null: false
    end
  end
end
