class CreateInstitutionHasAmenities < ActiveRecord::Migration
  def change
    create_table :institution_has_amenities do |t|
      t.string :hours
      t.integer :amenity_id
      t.integer :institution_id
      t.decimal :fees
      t.integer :capacity
      t.text :desc
      t.timestamps null: false
    end
  end
end
