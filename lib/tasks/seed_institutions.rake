# BallardHomelessClinic = Institution.new({ name: "Ballard Homeless Clinic", 
#   desc: "Provides primary health care including: annual physicals, urgent/episodic care, wound care, chronic disease management, mental health and chemical dependency counseling, immunization adminstration, and limited lab testing", 
#   instructions: "Walk in appointments available, but scheduling apointments is encouraged."}) 
# BallardHomelessClinic.amenities = [Amenity.find(8)]
# BallardHomelessClinic.contact = Contact.new({
#     phone: "206-782-5939",
#     website: "www.neighborcare.org/clinics/neighborcare-health-ballard-homeless-clinic-nyer-urness-house"
#   })
# BallardHomelessClinic.institution_detail = InstitutionDetail.new({
#     hours: "No Hours Set"
#   })
# BallardHomelessClinic.locations = [Location.new({
#     streetLine1: "1753 NW 56th St",
#     streetLine2: "#200",
#     city: "Seattle",
#     state: "WA",
#     zip: "98107"
#   })]
# BallardHomelessClinic.save

# SacredHeartShelter = Institution.new({ name: "Sacred Heart Shelter", 
#   desc: "Provides temporary shelter for homeless families. Works with residents to develop goals, obtain health and dental care, job and parent training, childcare, and ongoing assistance towards the goal of locating stable housing", 
#   instructions: 
#   "* 'Schedule an appointment: Call 211 or 1-800-621-4636' 
#     * 'Meet with a Family Housing Connection specialist.' 
#     * 'Receive a follow up phone call when a housing resource becomes available.' 
#     * 'Meet with housing staff to ensure the best fit for your family'"})
#  SacredHeartShelter.amenities = Amenity.find(2,6)
#  SacredHeartShelter.contact = Contact.new({
#     phone: "206-284-4680",
#     website: "www.sacredheartseattle.com"
#   })
# SacredHeartShelter.institution_detail = InstitutionDetail.new({
#     hours: "No Hours Set"
#   })
#  SacredHeartShelter.locations = [Location.new({
#     streetLine1: "205 2nd Ave N",
#     city: "Seattle",
#     state: "WA",
#     zip: "98109"
#   })]
#  SacredHeartShelter.save

# SalvationArmyFoodBank = Institution.new({ name: "Salvation Army Food Bank", 
#   desc: "Food bank for Seattle residents in zip codes: 98101, 98102, 98104, 98108, 98109, 98112, 98118, 98119, 98121, 98122, 98134, 98144. Provides items for baby needs.", 
#   instructions: "Must have proof of address and ID for all household members. Limit of 3 emergency food bags per household per year."})
# SalvationArmyFoodBank.amenities = [Amenity.find(2)]
# SalvationArmyFoodBank.contact = Contact.new({
#     phone: "206-447-9944",
#     website: "www.salvationarmy.org"
#   })
# SalvationArmyFoodBank.institution_detail = InstitutionDetail.new({
#     hours: "No Hours Set"
#   })
# SalvationArmyFoodBank.locations = [Location.new({
#     streetLine1: "1101 Pike St",
#     city: "Seattle",
#     state: "WA",
#     zip: "98101"
#   })]
# SalvationArmyFoodBank.save

# StFrancisHouse = Institution.new({name: "St. Francis House", 
#   desc: "Provides clothing, furniture, food, and household items.",
#   instructions: "No one is ever turned away, all are welcome. Clients must visit in person, no phone calls please."})
# StFrancisHouse.amenities = Amenity.find(1,2)
# StFrancisHouse.contact = Contact.new({
#     email: "stfrancis@live.com",
#     phone: "206-621-0945",
#     website: "www.stfrancishouseseattle.org"
#   })
# StFrancisHouse.institution_detail = InstitutionDetail.new({
#     hours: "No Hours Set"
#   })
# StFrancisHouse.locations = [Location.new({
#     streetLine1: "169 12th Ave",
#     city: "Seattle",
#     state: "WA",
#     zip: "98122"
#   })]
# StFrancisHouse.save

seed_file = Rails.root.join('db', 'seeds', 'institutions.yml')
institutions = YAML::load_file(seed_file)

namespace :db do
  namespace :seed do
    task :institutions => :environment do
      institutions.each do |temp|
        name = temp["institution"]["name"]

        _temp = temp["institution"]
        _institution = {name: _temp["name"], desc: _temp["desc"], instructions: _temp["instructions"]}
        institution = Institution.find_by(name: name)
        if institution.present?
          institution.update(_institution)
        else
          institution = Amenity.create(_institution)
        end
      end
      # puts institutions
    end
  end
end
