class Institution < ActiveRecord::Base
	has_many :contacts
	has_many :institution_has_amenities
	has_many :amenities, through: :institution_has_amenities
end
