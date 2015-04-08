class CreateAmenities < ActiveRecord::Migration
  def change
    create_table :amenities do |t|
      t.string :name, null: false
      t.text :desc
      t.timestamps null: false
    end
  end
end
