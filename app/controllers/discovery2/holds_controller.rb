class Discovery2::HoldsController < ApiController

  def holds_list
    discovery_record = Discovery2::RecordRequest.new(params[:discovery_id]).record.to_hash
    hold_request = Discovery2::HoldRequest.new(params[:discovery_id], params[:patron_id]).combined_list
    discovery_record[:holds_list] = hold_request[:holds_list]
    respond_to do |format|
      format.any { render json: discovery_record.to_json }
    end
  end

  def place_request
    hold_request = Aleph::HoldRequest.new(params[:item_number])
    set_hold_request_values(hold_request)
    request_status = initiate_hold_request(hold_request)
    respond_to do |format|
      format.any { render json: hold_request_response(request_status).to_json, status: response_status(request_status) }
    end
  end

  private

  def set_hold_request_values(hold_request)
    [:pickup_location, :start_interest_date, :last_interest_date, :note].each do |field|
      if params[field].present?
        hold_request.send("#{field}=", params[field])
      end
    end
  end

  def initiate_hold_request(hold_request)
    if hold_request.valid_request?
       hold_request.place_hold_request
       hold_request.request_status.put_item_hold.reply_text
    else
      'Hold request is invalid'
    end
  end

  def hold_request_response(request_status)
    if request_status == 'ok'
      { status: 'Success', server_response: 'ok' }
    else
      { status: 'Failure', server_response: request_status }
    end
  end

  def response_status(request_status)
    if request_status == 'ok'
      :ok
    else
      :internal_server_error
    end
  end

end
