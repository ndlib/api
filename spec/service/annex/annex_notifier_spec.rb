require "spec_helper"

describe "AnnexNotifier" do

	let(:request_notifier) { AnnexNotifier.new }
	let(:request_fetcher) { AnnexRequestFetcher.new }

	describe "::initialize" do

		it "should know the Aleph outbound request directory" do
			expect(request_notifier.outbound_dir).to eq('spec/fixtures/aleph_data/outbound/')
		end

		it "should know the Aleph inbound request directory" do
			expect(request_notifier.inbound_dir).to eq('spec/fixtures/aleph_data/inbound/')
		end

		it "should know the Aleph request archive directory" do
			expect(request_notifier.archive_dir).to eq('spec/fixtures/aleph_data/archive/')
		end

	end

	describe "#barcode_present?" do

		it "find existing barcodes" do
			expect(request_notifier.barcode_present?('send', '00000015620719')).to be_truthy
		end

	end

	describe "#append_to_send" do

		it "appends the correct barcode" do
			request_notifier.append_to_send('0000000098765')
			expect(request_notifier.barcode_present?('send', '0000000098765')).to be_truthy
			request_notifier.remove_from_file('send', '0000000098765')
		end

	end

	describe "#append_to_stock" do

		it "appends the correct barcode" do
			request_notifier.append_to_stock('0000000098765')
			expect(request_notifier.barcode_present?('stock', '0000000098765')).to be_truthy
			request_notifier.remove_from_file('stock', '0000000098765')

		end

	end

	describe "#parse_transaction_number" do

		it "correctly parses a formatted transaction number" do
			expect(request_notifier.send(:parse_transaction_number, "aleph_123456789")).to eq "123456789"
		end

		it "correctly returns a non formatted transaction number" do
			expect(request_notifier.send(:parse_transaction_number, "123456789")).to eq "123456789"
		end

	end

	describe "#convert_filname" do

		it "correctly converts filename" do
			expect(request_notifier.send(:convert_filename, "aleph", "123456789")).to eq "aleph.123456789.json"
		end

	end

	describe "#archive_request" do

		it "archives an aleph request" do
			expect(request_fetcher.fetch_requests("outbound").count).to eq(20)
			request_notifier.archive_request("aleph", "000341846")
			expect(request_fetcher.fetch_requests("outbound").count).to eq(19)
			request_notifier.reactivate_request("aleph", "000341846")
		end

		it "archives an ill request" do
			expect(request_fetcher.fetch_requests("outbound").count).to eq(20)
			request_notifier.archive_request("illiad", "835708")
			expect(request_fetcher.fetch_requests("outbound").count).to eq(19)
			request_notifier.reactivate_request("illiad", "835708")
		end
	end

	describe "#reactivate_request" do

		it "reactivates an aleph request" do
			request_notifier.archive_request("aleph", "000341846")
			expect(request_fetcher.fetch_requests("outbound").count).to eq(19)
			request_notifier.reactivate_request("aleph", "000341846")
			expect(request_fetcher.fetch_requests("outbound").count).to eq(20)
		end

		it "reactivates an ill request" do
			request_notifier.archive_request("illiad", "835708")
			expect(request_fetcher.fetch_requests("outbound").count).to eq(19)
			request_notifier.reactivate_request("illiad", "835708")
			expect(request_fetcher.fetch_requests("outbound").count).to eq(20)
		end
	end
end
