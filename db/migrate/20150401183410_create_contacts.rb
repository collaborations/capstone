class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :value, null: false
      t.timestamps null: false
    end
  end
end
