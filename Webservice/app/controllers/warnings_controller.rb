class WarningsController < ApplicationController
  # GET /warnings
  # GET /warnings.json
  def index

    @radius = params[:radius].to_f / 1000

    @lonMin = params[:longitude].to_f - @radius
    @latMin = params[:latitude].to_f - @radius

    @lonMax = params[:longitude].to_f + @radius
    @latMax = params[:latitude].to_f + @radius

    @warnings = Warning.where("longitude <= ? AND longitude >= ?", @lonMax, @lonMin)
           .where("latitude <= ? AND latitude >= ?", @latMax, @latMin)


    render json: @warnings
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

end
