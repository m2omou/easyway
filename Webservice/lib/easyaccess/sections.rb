module EasyAccess
  class Sections

    # Get the unic STIF code of the line
    def self.getTransportLineCode(code, destination)
      @line = Line.where("name=? AND destination LIKE ? OR origin LIKE ?",
                         code,"%#{destination}%", "%#{destination}%").first
      return @line.nil? ? nil : @line.stif
    end

    # Check if the section is accessible
    def self.isSectionAccessible?(section)
      @info = section["display_informations"]
      if (!@info.nil?)
        @lineNumber = getTransportLineCode(@info["code"], @info["direction"])
        # Everything except walking mode
        if (!section["stop_date_times"].nil?)
          # Get the first and last stops to check if the person can access and got off the bus, train...
          @firstStop = section["stop_date_times"].first
          @lastStop = section["stop_date_times"].last
          if (!EasyAccess::Stops::checkFirstAndLastStops(@firstStop, @lastStop, @lineNumber))
            return false
          end
        end
      end
      return true
    end

    # Check if the section is accessible
    def self.isAllSectionsAccessible?(transport)
      transport["sections"].each do |section|
        if (!isSectionAccessible?(section))
          return false
        end
      end
      return true
    end

  end
end