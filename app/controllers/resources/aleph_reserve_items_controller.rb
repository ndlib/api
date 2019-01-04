class Resources::AlephReserveItemsController < ApiController

  public


  def all_aleph_reserves
    aleph_reserves = Resource::Aleph::ReserveItem.all_aleph_reserves
    if aleph_reserves.blank?
      render_404
    else
      respond_to do |format|
        format.xml { render :xml => aleph_reserves.to_xml(:root => 'api', :skip_types => true, :skip_instruct => true) }
        format.json { render :json => aleph_reserves.to_json }
      end
    end
  end

  def rta_status
    rta_items = Resource::Aleph::ReserveItem.item_status_by_doc_number(params[:rta_number])
    if rta_items.blank?
      render_404
    else
      respond_to do |format|
        format.xml { render :xml => rta_items.to_xml(:root => 'api', :skip_types => true, :skip_instruct => true) }
        format.json { render :json => rta_items.to_json }
      end
    end
  end

end
