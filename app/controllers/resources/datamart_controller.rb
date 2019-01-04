class Resources::DatamartController < ApiController
	
  def sublibraries
    sublibraries = Datamart::Sublibrary.new.retrieve_sublibraries

    respond_to do |format|
      format.xml { render xml: sublibraries }
      format.any { render json: sublibraries }
    end
  end
  
  def sublibrary_collections
    sublibrary_collections = Datamart::SublibraryCollection.new.retrieve_sublibrary_collections

    respond_to do |format|
      format.xml { render xml: sublibrary_collections }
      format.any { render json: sublibrary_collections }
    end
  end

end
