class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.integer :institution_id
      t.time :mon_open
      t.time :mon_close
      t.time :tue_open
      t.time :tue_close
      t.time :wed_open
      t.time :wed_close
      t.time :thu_open
      t.time :thu_close
      t.time :fri_open
      t.time :fri_close
      t.time :sat_open
      t.time :sat_close
      t.time :sun_open
      t.time :sun_close
      t.timestamps null: false
    end

    remove_column :institution_details, :hours, :string
  end
end
