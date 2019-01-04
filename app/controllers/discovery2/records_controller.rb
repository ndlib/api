class Discovery2::RecordsController < ApiController

  def show
    search = Discovery2::RecordDetailRequest.new(params[:q], params[:vid])
    respond_to do |format|
      format.xml { render xml: search.to_xml }
      format.any { render json: search.to_json }
    end
  end

  def detail
    search = Discovery2::RecordDetailRequest.new(params[:q], params[:vid])
    respond_to do |format|
      format.any { render json: search.to_json }
    end
  end

  def fullview
    search = Discovery2::FullviewRequest.new(params[:q], params[:vid])
    respond_to do |format|
      format.any { render json: search.to_json }
    end
  end

  def sfx
    data = Discovery2::SfxRequest.new(params, 'ndu')
    respond_to do |format|
      format.xml { render xml: data.body }
      format.any { render json: data.to_json }
    end
  end

  def holdings
    data = Discovery2::HoldingRequest.new(params[:q], 'ndu')
    respond_to do |format|
      format.xml { render xml: data.body }
      format.any { render json: data.to_json }
    end
  end

end
