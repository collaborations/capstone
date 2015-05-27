class Amenity < ActiveRecord::Base
	include PgSearch
	multisearchable :against => :name,
					:using => {
					    tsearch:    {dictionary: 'english'},
					    trigram:    {threshold:  0.1},
					    dmetaphone: {}
 					},
					:ignoring => :accents

	has_many :institution_has_amenities
	has_many :institutions, through: :institution_has_amenities
end
