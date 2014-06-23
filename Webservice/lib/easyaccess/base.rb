module EasyAccess
  class Base

    API_URL = "http://api.navitia.io/v1/"

    def initialize(args = {})
      @oauth_token = args.fetch(:oauth_token, nil)
      @version = args.fetch(:version, nil)
      @info = args.fetch(:info, nil)
    end

    def journeys()
      EasyAccess::Journeys.new(self, @info)
    end

    # make an http GET request to foursquare API and parse the json response
    def get(path, params={})
      params = merge_set_up_params(params)
      @token = "b3688c52-9235-45ca-b01f-c5b2b83a4f4f"
      @result = Typhoeus::Request.get(API_URL + path, :params => params,
                                      :headers => {"Authorization" => "Basic#{@token}"})
      puts @result.body
      # check if the url looks correct in the log
      puts @result.effective_url
      # parse the result to json
      return JSON.parse(@result.body)
    end

    private

    # merge the token & version to the parameters
    def merge_set_up_params(params)
      if (!@oauth_token.nil? && !@version.nil?)
        params.merge!(:oauth_token => @oauth_token)
        params.merge(:v => @version)
      end
      return params
    end

  end
end
