class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.integer :institution_id
      t.boolean :individual, default: false
      t.boolean :family, default: false
      t.boolean :male, default: false
      t.boolean :female, default: false
      t.integer :min_age, default: 0
      t.integer :max_age, default: 1000
      t.boolean :physical_disability, default: false
      t.boolean :mental_disability, default: false
      t.boolean :veteran, default: false
      t.boolean :abuse_victim, default: false
      t.timestamps null: false
    end
  end
end
