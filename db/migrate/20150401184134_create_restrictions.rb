class CreateRestrictions < ActiveRecord::Migration
  def change
    create_table :restrictions do |t|
      t.string :name, null: false
      t.string :desc
      t.timestamps null: false
    end
  end
end
