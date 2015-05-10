class Institution < ActiveRecord::Base
	has_many :contacts
	has_many :institution_has_amenities
	has_many :amenities, through: :institution_has_amenities
	has_many :locations
	has_many :restrictions

	accepts_nested_attributes_for :locations
	accepts_nested_attributes_for :amenities  
	accepts_nested_attributes_for :restrictions
end
