# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Amenity.all.destroy_all()
Amenity.create([{ name: "Clothing", img: "categories/clothing.svg", desc: "Provides clothes to patrons"}, 
	{ name: "Food", img: "categories/food.svg", desc: "Provides meals to homeless through coupons or for free"},
	{ name: "Bus Tickets", img: "categories/bustickets.svg", desc: "Provides a place to purchase bus tickets"},
	{ name: "Storage", img: "categories/storage.svg", desc: "Provides a place to store personal items"},
	{ name: "Recreation", img: "categories/recreation.svg", desc: "Has recreational things to do"},
	{ name: "Shelter", img: "categories/shelter.svg", desc: "Provides a place to stay overnight"},
	{ name: "Hygiene", img: "categories/hygiene.svg", desc: "Provides a shower"},
	{ name: "Medical", img: "categories/medical.svg", desc: "Has some amount of medical assistance"},
	{ name: "Hotline", img: "categories/hotline.svg", desc: "Number to call for help for various reasons"},
	{ name: "Employment", img: "categories/employment.svg", desc: "A place to offers assistance getting employed or is a job opening"}
])

# var = <model>.new({<field>: "<value>", <field2>: "<value>"}) 
# var.<model relation> = <active record association>
# var.save

# contact => phone | email | institution_id | website

# InstitutionDetail
      # t.string :hours
      # t.integer :institution_id
      # t.decimal :fees, null: false, default: 0
      # t.text :desc
      # t.integer :capacity, null: false, default: 0
      # t.timestamps null: false

SeattleUnionGospelMission = Institution.new({ name: "Seattle Union Gospel Mission: Men's Shelter", 
	desc: "Men's emergency overnight shelter providing clothing, meals, and art classes.", 
	instructions: "Maximum stay is 168 nights per year, conseutive or spread out. Call or walk in 9am - 6:30pm to reserve a ticket for the night.
	Clients who have reserved a ticket must arrive by 7:15pm to claim their mats. Clients without a ticket should line up for unclaimed mats beginning at 7:15pm. ID required. "})
SeattleUnionGospelMission.amenities = Amenity.find(1,2,5,6,8)
SeattleUnionGospelMission.contact = Contact.new({
		email: "mission@ugm.org",
		phone: "2067231076",
		website: "www.ugm.org"
	})
SeattleUnionGospelMission.institution_detail = InstitutionDetail.new({
		hours: "No Hours Set"
	})
SeattleUnionGospelMission.location = Location.new({
		streetLine1: "318 2nd Ave Extension South",
		city: "Seattle",
		state: "WA",
		zip: "98104"
	})
SeattleUnionGospelMission.save

BallardHomelessClinic = Institution.new({ name: "Ballard Homeless Clinic", 
	desc: "Provides primary health care including: annual physicals, urgent/episodic care, wound care, chronic disease management, mental health and chemical dependency counseling, immunization adminstration, and limited lab testing", 
	instructions: "Walk in appointments available, but scheduling apointments is encouraged."}) 
BallardHomelessClinic.amenities = [Amenity.find(8)]
BallardHomelessClinic.contact = Contact.new({
		phone: "2067825939",
		website: "www.neighborcare.org/clinics/neighborcare-health-ballard-homeless-clinic-nyer-urness-house"
	})
BallardHomelessClinic.institution_detail = InstitutionDetail.new({
		hours: "No Hours Set"
	})
BallardHomelessClinic.location = Location.new({
		streetLine1: "1753 NW 56th St",
		streetLine2: "#200",
		city: "Seattle",
		state: "WA",
		zip: "98107"
	})
BallardHomelessClinic.save

SacredHeartShelter = Institution.new({ name: "Sacred Heart Shelter", 
 	desc: "Provides temporary shelter for homeless families. Works with residents to develop goals, obtain health and dental care, job and parent training, childcare, and ongoing assistance towards the goal of locating stable housing", 
 	instructions: 
 	"* 'Schedule an appointment: Call 211 or 1-800-621-4636' 
 		* 'Meet with a Family Housing Connection specialist.' 
 		* 'Receive a follow up phone call when a housing resource becomes available.' 
 		* 'Meet with housing staff to ensure the best fit for your family'"})
 SacredHeartShelter.amenities = Amenity.find(2,6)
 SacredHeartShelter.contact = Contact.new({
		phone: "2062844680",
		website: "www.sacredheartseattle.com"
	})
SacredHeartShelter.institution_detail = InstitutionDetail.new({
		hours: "No Hours Set"
	})
 SacredHeartShelter.location = Location.new({
		streetLine1: "205 2nd Ave N",
		city: "Seattle",
		state: "WA",
		zip: "98109"
	})
 SacredHeartShelter.save

SalvationArmyFoodBank = Institution.new({ name: "Salvation Army Food Bank", 
	desc: "Food bank for Seattle residents in zip codes: 98101, 98102, 98104, 98108, 98109, 98112, 98118, 98119, 98121, 98122, 98134, 98144. Provides items for baby needs.", 
	instructions: "Must have proof of address and ID for all household members. Limit of 3 emergency food bags per household per year."})
SalvationArmyFoodBank.amenities = [Amenity.find(2)]
SalvationArmyFoodBank.contact = Contact.new({
		phone: "2064479944",
		website: "www.salvationarmy.org"
	})
SalvationArmyFoodBank.institution_detail = InstitutionDetail.new({
		hours: "No Hours Set"
	})
SalvationArmyFoodBank.location = Location.new({
		streetLine1: "1101 Pike St",
		city: "Seattle",
		state: "WA",
		zip: "98101"
	})
SalvationArmyFoodBank.save

StFrancisHouse = Institution.new({name: "St. Francis House", 
	desc: "Provides clothing, furniture, food, and household items.",
	instructions: "No one is ever turned away, all are welcome. Clients must visit in person, no phone calls please."})
StFrancisHouse.amenities = Amenity.find(1,2)
StFrancisHouse.contact = Contact.new({
		email: "stfrancis@live.com",
		phone: "2066210945",
		website: "www.stfrancishouseseattle.org"
	})
StFrancisHouse.institution_detail = InstitutionDetail.new({
		hours: "No Hours Set"
	})
StFrancisHouse.location = Location.new({
		streetLine1: "169 12th Ave",
		city: "Seattle",
		state: "WA",
		zip: "98122"
	})
StFrancisHouse.save

