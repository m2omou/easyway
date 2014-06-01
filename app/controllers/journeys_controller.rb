class JourneysController < ApplicationController
  include ActionController::MimeResponds
  require 'net/http'


  def index
    @from = params.has_key?(:from) ? params[:from] : nil
    @to = params.has_key?(:to) ? params[:to] : nil
    @datetime = params.has_key?(:datetime) ? params[:datetime] : nil

    result = JourneysHelper.getItinerary(@from, @to, @datetime)

    respond_to do |format|
      format.json { render :json => result["josurneys"] }
    end
  end
end
