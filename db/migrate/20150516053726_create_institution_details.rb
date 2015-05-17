class CreateInstitutionDetails < ActiveRecord::Migration
  def change
    create_table :institution_details do |t|
      t.string :hours
      t.integer :institution_id
      t.decimal :fees, null: false, default: 0
      t.integer :capacity, null: false, default: 0
      t.timestamps null: false
    end
  end
end
