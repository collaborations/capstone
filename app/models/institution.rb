class Institution < ActiveRecord::Base
	include PgSearch
	multisearchable :against => :name,
					:using => {
					    tsearch:    {dictionary: 'english'},
					    trigram:    {threshold:  0.1},
					    dmetaphone: {}
 					},
					:ignoring => :accents

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

	def self.search(search)
		if search
			temp = PgSearch.multisearch(search)
			temp.map { |s| s.searchable }
		else
			find(:all)
		end
	end

end
