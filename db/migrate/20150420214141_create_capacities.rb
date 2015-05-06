class CreateCapacities < ActiveRecord::Migration
  def change
    create_table :capacities do |t|
      t.integer :institution, null: false
      t.integer :reserved, default: 0
      t.integer :reserved_confirmed, default: 0
      t.integer :standby, default: 0
      t.timestamps null: false
    end
  end
end
