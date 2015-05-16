class ChangeInstitutionHasAmenity < ActiveRecord::Migration
  def change
    remove_column :capacity, :value, :string
    remove_column :desc, :value, :string
    remove_column :fees, :value, :string
    remove_column :hours, :value, :string
  end
end
