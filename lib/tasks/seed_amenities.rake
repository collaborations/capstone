amenities = [
  { name: "Clothing", img: "categories/clothing.svg", desc: "Provides clothes to patrons"}, 
  { name: "Food", img: "categories/food.svg", desc: "Provides meals to homeless through coupons or for free"},
  { name: "Bus Tickets", img: "categories/bustickets.svg", desc: "Provides a place to purchase bus tickets"},
  { name: "Storage", img: "categories/storage.svg", desc: "Provides a place to store personal items"},
  { name: "Recreation", img: "categories/recreation.svg", desc: "Has recreational things to do"},
  { name: "Shelter", img: "categories/shelter.svg", desc: "Provides a place to stay overnight"},
  { name: "Hygiene", img: "categories/hygiene.svg", desc: "Provides a shower"},
  { name: "Medical", img: "categories/medical.svg", desc: "Has some amount of medical assistance"},
  { name: "Hotline", img: "categories/hotline.svg", desc: "Number to call for help for various reasons"},
  { name: "Employment", img: "categories/employment.svg", desc: "A place that offers assistance getting employed"}
]

namespace :db do
  namespace :seed do
    desc "Creates or updates all amenities"
    task :amenities => :environment do
      amenities.each do |temp|
        amenity = Amenity.find_by(name: temp[:name])
        puts temp[:name]
        if amenity.present?
          amenity.update(temp)
        else
          Amenity.create(temp)
        end
      end
    end
  end
end

