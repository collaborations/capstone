class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :streetLine1, null: false
      t.string :streetLine2
      t.string :city
      t.string :state
      t.string :zip
      t.timestamps null: false
    end
  end
end
