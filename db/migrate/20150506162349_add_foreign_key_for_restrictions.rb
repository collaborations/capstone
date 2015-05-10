class AddForeignKeyForRestrictions < ActiveRecord::Migration
  def change
  	add_column :restrictions, :institution_id, :integer  
  end
end
