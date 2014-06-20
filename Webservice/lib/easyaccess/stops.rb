module EasyAccess
  class Stops

    # Check if all the stop of the line are accessible
    def self.isStopsAccessible?(stops, lineNumer)
      stops.each do |stop|
        @name = reformatStopName(stop["stop_point"]["name"])
        @stop = Stop.where("name LIKE ? AND stif LIKE ?", "%#{@name}%", "%#{lineNumer}%").first
        @stop.nil? ? true : @stop.accessibility
      end
    end

    # Check the accessibility only to a specific stop
    def self.isStopAccessible?(stop, lineNumer)
      @name = reformatStopName(stop["stop_point"]["name"])
      @stop = Stop.where("name LIKE ? AND stif LIKE ?", "%#{@name}%", "%#{lineNumer}%").first
      @stop.nil? ? true : @stop.accessibility
    end

    def self.reformatStopName(name)
      return name.gsub(" - ","-")
    end

  end

end