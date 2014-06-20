class WarningsController < ApplicationController
  # GET /warnings
  # GET /warnings.json
  def index
    @defaultRadius = 50
    # Get parameters
    @radius = params.has_key?(:radius) ? params[:radius].to_f / 1000 : 50 / 1000

    if (params.has_key?(:longitude) && params.has_key?(:latitude))
      @lonMin = params[:longitude].to_f - @radius
      @latMin = params[:latitude].to_f - @radius

      @lonMax = params[:longitude].to_f + @radius
      @latMax = params[:latitude].to_f + @radius

      # Finding nearby locations within a given radius (square method)
      @warnings = Warning.where("longitude <= ? AND longitude >= ?", @lonMax, @lonMin)
                         .where("latitude <= ? AND latitude >= ?", @latMax, @latMin)
      @data = jsonResponseFormat(0, "success", @warnings)
    else
      @data = jsonResponseFormat(1, "error", {:error => "Please provide the longitude, latidute and datetime"})
    end
    render json: @data
  end

  # GET /warnings/1
  # GET /warnings/1.json
  def show
    @warning = Warning.find(params[:id])
    render json: @warning
  end

  # POST /warnings
  # POST /warnings.json
  def create
    @warning = Warning.new(warning_params)

    if @warning.save
      render json: @warning, status: :created, location: @warning
    else
      render json: @warning.errors, status: :unprocessable_entity
    end
  end

  # DELETE /warnings/1
  # DELETE /warnings/1.json
  def destroy
    @warning = Warning.find(params[:id])
    @warning.destroy

    head :no_content
  end

  private

  def warning_params
    params.require(:warning).permit(:longitude, :latitude, :picture, :description)
  end

  # json return format
  def jsonResponseFormat(responseCode, responseMessage, result)
    return { :responseCode => responseCode,
             :responseMessage => responseMessage,
             :result => result }
  end

end
