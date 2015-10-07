module LocationHelper
  def getDirectionsLink(location)
    address = location.streetLine1 + " "
    address << location.streetLine2 + " " if location.streetLine2.present?
    address << location.city + ", " + location.state + " " + location.zip.to_s
    "https://www.google.com/maps?saddr=Current+Location&daddr="+address.sub(/\s/, "+")

  end

	def getLatLong(institution)
	  begin
	    location = institution.locations.first
	    address = location.streetLine1 + " "
	    address << location.streetLine2 + " " if location.streetLine2.present?
	    address << location.city + ", " + location.state + " " + location.zip.to_s
	    url = Settings.google.geocode.url + "api_key=" + Settings.google.token + "&address=" + address.sub(/\s/, "+")
	    response = JSON.parse(Faraday.get(url).body)['results']
	    Rails.logger.debug response
	    data = response[0]['geometry']['location']
	    location.lat = data['lat']
	    location.long = data['lng']
	    location.save
	  rescue NoMethodError => e
	    Rails.logger.error e
	  end
	end
	
end
