class Institution < ActiveRecord::Base
	has_many :institution_has_amenities
	has_many :amenities, through: :institution_has_amenities
	has_many :locations
	has_many :restrictions
  has_many :subscribers
  has_one :contact
  has_one :institution_detail

	accepts_nested_attributes_for :contact
	accepts_nested_attributes_for :locations
	accepts_nested_attributes_for :amenities  
	accepts_nested_attributes_for :restrictions

end
