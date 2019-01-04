class Resources::AlephController < ApiController

	skip_before_filter :verify_authenticity_token

	def aleph_item
		item = Aleph::Item.new(params[:barcode])
		if item.exists?
			respond_to do |format|
				format.any { render :json => item.to_json }
			end
		else
			render_404_json
		end
	end

	def stock_aleph_item
		item = Aleph::Item.new(params[:barcode])
		if item.exists?
			AnnexNotifier.new.append_to_stock(item.barcode)
			return_value = item.update_process_status('')
			respond_to do |format|
				if return_value[:status] == "error"
					format.any { render json: return_value, status: :unprocessable_entity }
				else
					format.any { render json: return_value, status: :ok }
				end
			end
		else
			render_404_json
		end
	end

	def deaccession_item
		item = Aleph::Item.new(params[:barcode])
		if item.exists?
			return_value = item.update_process_status('AR')
			respond_to do |format|
				if return_value[:status] == "error"
					format.any { render json: return_value, status: :unprocessable_entity }
				else
					format.any { render json: return_value, status: :ok }
				end
			end
		else
			render_404_json
		end
	end

	def active_requests
		request_fetcher = AnnexRequestFetcher.new
		requests = request_fetcher.fetch_requests('outbound')# .map { |request| request.to_json }
		if requests.count >= 1
			respond_to do |format|
				format.any { render :json => {requests: requests} }
			end
		else
			respond_to do |format|
				format.any { render :json => {requests: [] } }
			end
		end
	end

	def send_fulfillment
		item = Aleph::Item.new(params[:barcode])
		if item.exists?
			annex_notifier = AnnexNotifier.new
			annex_notifier.append_to_send(item.barcode) unless annex_notifier.barcode_present?('send', item.barcode)
			annex_notifier.archive_request(params[:source], params[:transaction_num])
			respond_to do |format|
				format.any { render :json => {status: "OK", message: "Item status sent to ILS"}.to_json }
			end
		else
			render_404_json
		end
	end

	def scan_fulfillment
		item = Aleph::Item.new(params[:barcode])
		if item.exists?
			annex_notifier = AnnexNotifier.new
			annex_notifier.archive_request(params[:source], params[:transaction_num])
			respond_to do |format|
				format.any { render :json => {status: "OK", message: "Scan request archived"}.to_json }
			end
		else
			render_404_json
		end
	end

	def archive_request
		annex_notifier = AnnexNotifier.new
		annex_notifier.archive_request(params[:source], params[:transaction_num])
		respond_to do |format|
			format.any { render :json => {status: "OK", message: "Request archived"}.to_json }
		end
	end
end
