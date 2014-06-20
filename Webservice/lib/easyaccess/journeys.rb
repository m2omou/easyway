module EasyAccess
  class Journeys

    def initialize(api)
      @api = api
    end

    # search venues by latitude & longitude
    def itinerary(info)
      # To avoid certain lines, modes ...
      @arrays = arraysWithoutIndex(info[:forbidden_uris])

      # Make an http GET request to foursquare API and parse the json response
      @journeys = @api.get("journeys" + @arrays, {:from => info[:from],
                                                      :to => info[:to],
                                                      :datetime => info[:datetime],
                                                      :type => info[:type]})
      # Check if any errors
      if (!@journeys["error"].nil?)
        return @journeys["error"], -1
      end
      return calculateItinerary(@journeys["journeys"]), 0
    end

    # If the itinerary is not accessible, find another way
    def findOtherItinerary()

    end

    # Get the unic STIF code of the line
    def getTransportLineCode(code, destination)
        @line = Line.where("name=? AND destination LIKE ? OR origin LIKE ?",
                           code,"%#{destination}%", "%#{destination}%").first
        return @line.nil? ? nil : @line.stif
    end

    def reformatStopName(name)
      return name.gsub(" - ","-")
    end

    # Check each stop is accessible
    def checkStopsAccessibility(stops, lineNumer)
      stops.each do |stop|
        @name = reformatStopName(stop["stop_point"]["name"])
        @stop = Stop.where("name LIKE ? AND stif LIKE ?", "%#{@name}%", "%#{lineNumer}%").first
        stop.nil? ? true : @stop.accessibility
      end
    end

    def checkAccessibility(transport)
      @info = transport["display_informations"]
      if (!@info.nil?)
        @lineNumber = getTransportLineCode(@info["code"], @info["direction"])
        if (!transport["stop_date_times"].nil?)
          #checkStopsAccessibility(transport["stop_date_times"], @lineNumber)
        end
      end
    end

    # Calculate an accessible itinerary
    def calculateItinerary(journeys)
      journeys.each do |journey|
        journey["sections"].each do |section|
          checkAccessibility(section)
        end
      end
      return journeys
    end

    # Typhoeus insert [] with index when sending http array.
    # CanalTP API, don't support arrays with index.
    def arraysWithoutIndex(data)
      @url = "?"
      data.each do |item|
        @url += "forbidden_uris[]=physical_mode:#{item}&"
      end
      return @url
    end

  end

end