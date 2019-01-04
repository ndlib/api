class Resources::AthleticsController < ApplicationController
  def schedule
    if params[:year].present?
      year = params[:year]
    else
      year = Resource::Athletics::Schedule.current_school_year
    end
    @schedule = Resource::Athletics::Schedule.new(year)
    respond_to do |format|
      format.any { render json: @schedule.to_json }
    end
  end
end
