class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.time :mon
      t.time :tue
      t.time :wed
      t.time :thu
      t.time :fri
      t.time :sat
      t.time :sun
      t.timestamps null: false
    end

    remove_column :institution_details, :hours, :string
  end
end
