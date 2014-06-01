module JourneysHelper

  # get the itinerary from CANALTP API
  def   self.getItinerary(from, to, date)
    source = 'http://api.navitia.io/v1/journeys?'
    source += 'from=' + from.to_s.gsub(",", ";")
    source += '&to=' + to.to_s.gsub(",", ";")
    source += '&datetime=' + date.to_s
    source += '&forbidden_uris[]=physical_mode%3ARapidTransit&forbidden_uris[]=physical_mode%3ATramway&forbidden_uris[]=physical_mode%3AMetro&forbidden_uris[]=physical_mode%3ACheckOut&forbidden_uris[]=physical_mode%3ACheckIn&forbidden_uris[]=physical_mode%3Adefault_physical_mode'
    # parse the json response
    return JSON.parse(Net::HTTP.get_response(URI.parse(source)).body)
  end

end
