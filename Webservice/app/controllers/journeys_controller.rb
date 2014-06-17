class JourneysController < ApplicationController
  include ActionController::MimeResponds
  require 'net/http'

  def index
    respond_to do |format|
      if (!params.has_key?(:from) || !params.has_key?(:to) || !params.has_key?(:datetime))
        @data = jsonResponseFormat(1, "error", {:result => "Please provide the longitude, latidute and datetime"})
      else
        # get the itinerary from CANALTP API
        @result = JourneysHelper.getItinerary(params[:from], params[:to], params[:datetime])
        # check if an error is returned
        if (@result.nil? || !@result["error"].nil?)
          @data = @result.nil? ? nil : jsonResponseFormat(1, "error", {:error => @result["error"]})
        else
          @data = jsonResponseFormat(0, "success", @result)#["journeys"])
        end
      end
      format.json { render :json => @data }
    end
  end

  private
  # json return format
  def jsonResponseFormat(responseCode, responseMessage, result)
    return { :responseCode => responseCode,
             :responseMessage => responseMessage,
             :result => result }
  end


end
