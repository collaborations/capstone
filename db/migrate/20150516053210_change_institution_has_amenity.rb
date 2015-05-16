class ChangeInstitutionHasAmenity < ActiveRecord::Migration
  def change
    remove_column :institution_has_amenities, :capacity, :integer
    remove_column :institution_has_amenities, :desc, :text
    remove_column :institution_has_amenities, :fees, :decimal
    remove_column :institution_has_amenities, :hours, :string
  end
end
