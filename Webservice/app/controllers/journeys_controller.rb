class JourneysController < ApplicationController
  include ActionController::MimeResponds
  require 'net/http'

  def index
    respond_to do |format|
      if (!params.has_key?(:from) || !params.has_key?(:to) || !params.has_key?(:datetime))
        @data = ApplicationHelper.jsonResponseFormat(1, "error",
                                                     {:result => "Please provide the longitude, latidute and datetime"})
      else
        @result = JourneysHelper.getItinerary(params[:from], params[:to], params[:datetime])
        @data = ApplicationHelper.jsonResponseFormat(0, "success",
                                                     {:result => @result["journeys"]})
      end
      format.json { render :json => @data }
    end
  end
end
