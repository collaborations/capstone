# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

SeattleUnionGospelMission = Institution.new({ name: "Seattle Union Gospel Mission: Men's Shelter", 
	desc: "Men's emergency overnight shelter providing clothing, meals, and art classes.", 
	instructions: "Maximum stay is 168 nights per year, conseutive or spread out. Call or walk in 9am - 6:30pm to reserve a ticket for the night.
	Clients who have reserved a ticket must arrive by 7:15pm to claim their mats. Clients without a ticket should line up for unclaimed mats beginning at 7:15pm. ID required. "})
SeattleUnionGospelMission.amenities = Amenity.find(1,2,5,6,8)
SeattleUnionGospelMission.save

BallardHomelessClinic = Institution.new({ name: "Ballard Homeless Clinic", 
	desc: "Provides primary health care including: annual physicals, urgent/episodic care, wound care, chronic disease management, mental health and chemical dependency counseling, immunization adminstration, and limited lab testing", 
	instructions: "Walk in appointments available, but scheduling apointments is encouraged."}) 
BallardHomelessClinic.amenities = [Amenity.find(8)]
BallardHomelessClinic.save

SacredHeartShelter = Institution.new({ name: "Sacred Heart Shelter", 
 	desc: "Provides temporary shelter for homeless families. Works with residents to develop goals, obtain health and dental care, job and parent training, childcare, and ongoing assistance towards the goal of locating stable housing", 
 	instructions: 
 	"* 'Schedule an appointment: Call 211 or 1-800-621-4636' 
 		* 'Meet with a Family Housing Connection specialist.' 
 		* 'Receive a follow up phone call when a housing resource becomes available.' 
 		* 'Meet with housing staff to ensure the best fit for your family'"})
 SacredHeartShelter.amenities = Amenity.find(2,6)
 SacredHeartShelter.save

SalvationArmyFoodBank = Institution.new({ name: "Salvation Army Food Bank", 
	desc: "Food bank for Seattle residents in zip codes: 98101, 98102, 98104, 98108, 98109, 98112, 98118, 98119, 98121, 98122, 98134, 98144. Provides items for baby needs.", 
	instructions: "Must have proof of address and ID for all household members. Limit of 3 emergency food bags per household per year."})
SalvationArmyFoodBank.amenities = [Amenity.find(2)]
SalvationArmyFoodBank.save

StFrancisHouse = Institution.new({name: "St. Francis House", 
	desc: "Provides clothing, furniture, food, and household items.",
	instructions: "No one is ever turned away, all are welcome. Clients must visit in person, no phone calls please."})
StFrancisHouse.amenities = Amenity.find(1,2)
StFrancisHouse.save

