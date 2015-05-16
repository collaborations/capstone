class CreateInstitutionDetails < ActiveRecord::Migration
  def change
    create_table :institution_details do |t|

      t.timestamps null: false
    end
  end
end
