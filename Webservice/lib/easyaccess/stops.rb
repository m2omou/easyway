module EasyAccess
  class Stops

    # Check if all the stop of the line are accessible
    def self.isStopsAccessible?(stops, lineNumer)
      @accessible = true
      stops.each do |stop|
        @name = reformatStopName(stop["stop_point"]["name"])
        if isStopAccessible?(@name, lineNumer) == false
          return false
        end
      end
      return true
    end

    # Check the accessibility only to a specific stop
    def self.isStopAccessible?(stop, lineNumer)
      @name = reformatStopName(stop["stop_point"]["name"])
      @stop = Stop.where("name LIKE ? AND stif LIKE ?", "%#{@name}%", "%#{lineNumer}%").first
      return @stop.nil? ? true : @stop.accessibility
    end

    def self.checkFirstAndLastStops(first, last, lineNumer)
       return isStopAccessible?(first, lineNumer) && isStopAccessible?(last, lineNumer)
    end

    def self.reformatStopName(name)
      return name.gsub(" - ","-")
    end

  end
end