class CreateInstitutionDetails < ActiveRecord::Migration
  def change
    create_table :institution_details do |t|
      t.string :hours
      t.integer :institution_id
      t.decimal :fees
      t.text :desc
      t.integer :capacity
      t.timestamps null: false
    end
  end
end
