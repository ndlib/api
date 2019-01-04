require "spec_helper"

describe "AnnexRequestFetcher" do

	let(:request_fetcher) { AnnexRequestFetcher.new }

	describe "::initialize" do

		it "should know the Aleph outbound request directory" do
			expect(request_fetcher.outbound_dir).to eq('spec/fixtures/aleph_data/outbound/')
		end

		it "should know the Aleph inbound request directory" do
			expect(request_fetcher.inbound_dir).to eq('spec/fixtures/aleph_data/inbound/')
		end

		it "should know the Aleph request archive directory" do
			expect(request_fetcher.archive_dir).to eq('spec/fixtures/aleph_data/archive/')
		end

	end

	describe "#fetch_requests" do

		it "determines the correct number of requests" do
			expect(request_fetcher.fetch_requests('outbound').count).to eq(20)
		end

	end

	describe "#parse_request" do

		let(:request_record) { request_fetcher.fetch_requests('outbound')[2] }

		it "parses the correct transaction id" do
			expect(request_record[:transaction]).to eq('aleph-000341845')
		end

		it "parses the request type" do
			expect(request_record[:request_type]).to eq('Doc Del')
		end

		it "parses the request source" do
			expect(request_record[:source]).to eq('Aleph')
		end

	end

	describe "#files_to_parse" do
		let(:dir_type) { "outbound" }

		it "returns the correct number of files" do
			expect(request_fetcher.send(:files_to_parse, dir_type).count).to eq(20)
		end

		context "backup file" do
			let(:dir) { request_fetcher.send(:open_dir, dir_type) }
			let(:backup_filename) { ".backup.swp" }
			let(:backup_path) { File.join(dir.path, backup_filename) }

			it "ignores backup files" do
				expect { FileUtils.touch(backup_path) }.to change { dir.entries.count }.by(1)
				expect(request_fetcher.send(:files_to_parse, dir_type)).to_not include(backup_path)
			end

			after do
				if File.file?(backup_path)
					File.delete(backup_path)
				end
			end

		end
	end

end
