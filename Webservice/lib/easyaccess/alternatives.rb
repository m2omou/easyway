module EasyAccess
  class Alternatives

    def initialize(api, info)
      @api = api
      @info = info
    end

    def accessibilityBetweenTwoStops(from, to, datetime)
      @from = "#{from["lon"]};#{from["lat"]}"
      @to = "#{to["lon"]};#{to["lat"]}"
      @arrays = EasyAccess::Utils::arraysWithoutIndex(@info[:forbidden_uris])

      @journeys = @api.get("journeys" + @arrays,
                           {:from => @from, :to => @to, :datetime => datetime, :type => @info[:type]})
      @journeys["journeys"].each do |journey|
        if EasyAccess::Sections::isAllSectionsAccessible?(journey) == true
          return journey
        end
      end
      return nil
    end

    # If the itinerary is not accessible, find another alternative
    def findAlternative(section, initiary, index)
      @details = section["display_informations"]
      if (!@details.nil?)
        @lineNumber = EasyAccess::Sections::getTransportLineCode(@info["code"], @info["direction"])
        @sectionNumber = index
        if (!initiary[index].nil?)
          initiary.drop(index).each do | sct |
            if (!sct["stop_date_times"].nil?)
              @sectionNumber = @sectionNumber + 1
              @from = section["from"]["stop_point"]
              @to = sct["from"]["stop_point"]
              @alt = accessibilityBetweenTwoStops(@from["coord"], @to["coord"], section["departure_date_time"])
              if (!@alt.nil?)
                return @alt["sections"], @sectionNumber
              end
            end
          end
          end
        return nil, index
      end
      return section, false
    end

  end
end