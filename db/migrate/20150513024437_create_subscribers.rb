class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :phone, null: false
      t.integer :institution_id, null: false
      t.timestamps null: false
    end
  end
end
