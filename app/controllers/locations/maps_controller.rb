class Locations::MapsController < ApiController


  def index
    maps = Location::Maps.new(params)

    respond_to do |format|
      format.xml { render xml: maps }
      format.any { render json: maps }
    end
  end
end
