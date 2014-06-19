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



      return @journeys["journeys"], 0
    end

    # If the itinerary is not accessible, find another way
    def findOtherItinerary()

    end

    # Get the unic STIF code
    def getStifCode(code, direction)
        return 1
    end

    # Check if the itinerary is accessible
    def checkAccebility(journeys)
      journeys.each do |item|
        if (item.type != "street_network" && !item.display_informations.nil?)
          @stif = getStifCode(item.display_informations.code, item.display_informations.direction)


        end
      end
      return true
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