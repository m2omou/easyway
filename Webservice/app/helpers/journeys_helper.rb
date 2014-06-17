module JourneysHelper

  API_URL = "http://api.navitia.io/v1/"

  # get the itinerary from CANALTP API
  def   self.getItinerary(from, to, date)
    @params = Hash.new()
    @params[:from] = from.to_s.gsub(",", ";")
    @params[:to] = to.to_s.gsub(",", ";")
    @params[:datetime] = date.to_s
    # To avoid certain lines, modes ...
    @forbidden_uris = ["RapidTransit","Tramway","Metro","CheckOut","CheckIn","default_physical_mode"]
    # convert the array to http paramters
    @transports = parseForbiddenTransports(@forbidden_uris)
    return get("journeys", @transports, @params)
  end

  # make an http GET request to foursquare API and parse the json response
  def self.get(path, transports, params={})
    @result = Typhoeus::Request.get(API_URL + path + transports, :params => params)
    # check if the url looks correct in the log
    puts @result.effective_url
    # parse the result to json
    JSON.parse(@result.body)
  end

  # Typhoeus insert [] with index when sending http array.
  # CanalTP API, don't support arrays with index.
  def self.parseForbiddenTransports(data)
    @url = "?"
    data.each do |item|
      @url += "forbidden_uris[]=physical_mode:#{item}&"
    end
    return @url
  end

end
