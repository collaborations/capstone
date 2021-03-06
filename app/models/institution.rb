class Institution < ActiveRecord::Base
	has_many :institution_has_amenities
	has_many :amenities, through: :institution_has_amenities
  has_many :capacities
	has_many :locations
	has_many :restrictions
	has_many :subscribers
	
  has_one :contact
  has_one :filter
  has_one :hours
	has_one :institution_detail

	accepts_nested_attributes_for :amenities  
  accepts_nested_attributes_for :contact
  accepts_nested_attributes_for :hours
  accepts_nested_attributes_for :institution_detail
  accepts_nested_attributes_for :locations
	accepts_nested_attributes_for :restrictions
  accepts_nested_attributes_for :filter

	include PgSearch
	pg_search_scope :all_scope, :against => {:name => 'A', :desc => 'B'},
					:associated_against	=> {
						:amenities => :name
					},
					:using => {
					    tsearch:    {dictionary: 'english'},
					    trigram:    {threshold:  0.1},
					    dmetaphone: {}
 					}


	def self.search(search)
		if search and search != ""
			Institution.all_scope(search)
		else
			Institution.all
		end
	end

end
