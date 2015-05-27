class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.boolean :individual
      t.boolean :family
      t.boolean :male
      t.boolean :female
      t.integer :min_age
      t.integer :max_age
      t.boolean :physical_disability
      t.boolean :mental_disability
      t.boolean :veteran
      t.boolean :abuse_victim
      t.timestamps null: false
    end
  end
end
