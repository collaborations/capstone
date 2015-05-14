class AddLatLongToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :lat, :decimal
    add_column :locations, :long, :decimal
  end
end
