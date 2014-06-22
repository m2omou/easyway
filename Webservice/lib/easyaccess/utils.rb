module EasyAccess
  class Utils
    # Typhoeus insert [] with index when sending http array.
    # CanalTP API, don't support arrays with index.
    def self.arraysWithoutIndex(data)
      @url = "?"
      data.each do |item|
        @url += "forbidden_uris[]=physical_mode:#{item}&"
      end
      return @url
    end
  end
end