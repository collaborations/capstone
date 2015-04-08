class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :name, null: false
      t.text :desc
      t.text :instructions
      t.timestamps null: false
    end
  end
end
