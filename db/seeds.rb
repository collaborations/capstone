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

sugc = Institution.new({ name: "Seattle Union Gospel Church", desc: "Providing help to all those in need"})
sugc.amenities = Amenity.find(2,3,6)
sugc.save
