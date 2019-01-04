class Resources::DiscoveryController < ApplicationController
  def index
    search = Resource::Discovery.new(params[:q], params[:search_type])
    respond_to do |format|
      format.any { render json: search.to_json }
    end
  end
end
