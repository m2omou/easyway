class LinesController < ApplicationController
  # GET /lines
  # GET /lines.json
  def index
    @lines = Line.all

    render json: @lines
  end

  # GET /lines/1
  # GET /lines/1.json
  def show
    @line = Line.find(params[:id])

    render json: @line
  end

  # POST /lines
  # POST /lines.json
  def create
    @line = Line.new(params[:line])

    if @line.save
      render json: @line, status: :created, location: @line
    else
      render json: @line.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lines/1
  # PATCH/PUT /lines/1.json
  def update
    @line = Line.find(params[:id])

    if @line.update(params[:line])
      head :no_content
    else
      render json: @line.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lines/1
  # DELETE /lines/1.json
  def destroy
    @line = Line.find(params[:id])
    @line.destroy

    head :no_content
  end
end
