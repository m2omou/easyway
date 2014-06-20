module EasyAccess
  require 'Typhoeus'

  class Base

    API_URL = "http://api.navitia.io/v1/"

    def initialize(args = {})
      @oauth_token = args.fetch(:oauth_token, nil)
      @version = args.fetch(:version, nil)
    end

    def journeys()
      EasyAccess::Journeys.new(self)
    end

    # make an http GET request to foursquare API and parse the json response
    def get(path, params={})
      params = merge_set_up_params(params)
      @result = Typhoeus::Request.get(API_URL + path, :params => params)
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