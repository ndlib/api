class Locations::HoursController < ApiController

  private

  def search_date
    params[:date] ||= Date.today
  end

  def search_codes
    unless params.has_key?(:codes)
      params[:code]
    end

    params[:codes]
  end


  public

  def index
    hours = current_service.api.new(search_codes, search_date)

    respond_to do |format|
      format.any { render :text => hours.retrieve_hours() }
    end

  end

end
