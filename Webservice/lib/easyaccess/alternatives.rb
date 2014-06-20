module EasyAccess
  class Alternatives

    def initialize(api, info)
      @api = api
      @info = info
    end

    # If the itinerary is not accessible, find another alternative
    def findAlternative(section)
      @arrays = EasyAccess::Utils::arraysWithoutIndex(@info[:forbidden_uris])
      @journeys = @api.get("journeys" + @arrays,
                           {:from => @info[:from], :to => @info[:to],
                            :datetime => @info[:datetime], :type => @info[:type]})
      return section, true
    end

  end
end