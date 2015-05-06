# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Amenity.create([{ name: "Clothing", desc: "Provides clothes to patrons" }, 
	{ name: "Food", desc: "Provides meals to homeless through coupons or for free" },
	{ name: "Bus Tickets", desc: "Provides a place to purchase bus tickets" },
	{ name: "Storage", desc: "Provides a place to store personal items"},
	{ name: "Recreation", desc: "Has recreational things to do"},
	{ name: "Shelter", desc: "Provides a place to stay overnight"},
	{ name: "Hygiene", desc: "Provides a shower"},
	{ name: "Medical", desc: "Has some amount of medical assistance"},
	{ name: "Hotline", desc: "Number to call for help for various reasons"},
	{ name: "Employment", desc: "A place to offers assistance getting empoyed or is a job opening"}
])
