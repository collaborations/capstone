class CreateContactTypes < ActiveRecord::Migration
  def change
    create_table :contact_types do |t|
      t.string :type, null: false
      t.timestamps null: false
      t.integer :contact_id
    end
  end
end
