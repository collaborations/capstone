class ChangeContactInfo < ActiveRecord::Migration
  def change
    add_column :contacts, :phone, :string
    add_column :contacts, :email, :string
    add_column :contacts, :institution_id, :integer
    add_column :contacts, :website, :string
    remove_column :contacts, :value, :string
  end
end
