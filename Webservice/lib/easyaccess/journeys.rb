module EasyAccess
  require 'easyaccess/sections'
  require 'easyaccess/stops'
  require 'easyaccess/alternatives'

  class Journeys
    def initialize(api)
      @api = api
    end

    # search venues by latitude & longitude
    def itinerary(info)
      # To avoid certain lines, modes ...
      @arrays = arraysWithoutIndex(info[:forbidden_uris])
      # Make an http GET request to foursquare API and parse the json response
      @journeys = @api.get("journeys" + @arrays,
                           {:from => info[:from], :to => info[:to],
                            :datetime => info[:datetime], :type => info[:type]})
      # Check if any errors
      if (!@journeys["error"].nil?)
        return @journeys["error"], -1
      end
      return calculateItinerary(@journeys["journeys"]), 0
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

    # Fist check if one of the suggested Itineraries is accessible
    def itineraryAccessible?(journeys)
      # a finir
      journeys.each do |journey|
        journey["sections"].each do |section|
          #checkSectionAccessibility(section)
        end
      end
    end

    def calculateItineraryDuration(itinerary)
      # Initialize
      itinerary[:duration] = 0
      itinerary[:nb_transfers] = 0

      itinerary[:sections].each do |section|
        # Add the duration of each section
        itinerary[:duration] += section["duration"].to_i
        # Count the number of transfer
        if (section["type"] == "transfer")
          itinerary[:nb_transfers] += 1
        end
      end

      # TO DO
      itinerary[:arrival_date_time]
      itinerary[:type]
    end

    # Calculate an accessible itinerary
    def calculateItinerary(journeys)
      @itinerary = Hash.new()
      @itinerary[:sections] = Array.new()
      @section = journeys.first

      if (!@section.nil?)
        # Save the departure date
        @itinerary[:departure_date_time] = @section["departure_date_time"]
        @itinerary[:requested_date_time] = @section["requested_date_time"]
        # Loop through all the sections except the waiting ones
        @section["sections"].each do |section|
          if (section["type"] != "waiting")
            # Before adding this section, check the Accessibility where the person got off the bus, train...
            if (EasyAccess::Sections::isSectionAccessible?(section) == true)
              section["accessible"] = true
              @itinerary[:sections].push(section)
            else
              section["accessible"] = false
              # If not accessible then find another way
              EasyAccess::Alternatives::findAlternative(section)
              # If no way found, still show that section by showing a warning.


            end
          end
        end
        # Now calculate the duration of the itinerary
        calculateItineraryDuration(@itinerary)
      end
      return @itinerary
    end

  end

end