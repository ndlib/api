require "spec_helper"

describe Resource::Annex::Request do
	let(:aleph_hash) {
		{
			"transaction" => "transaction_value",
			"request_type" => "request_type_value",
			"delivery_type" => "delivery_type_value",
			"source" => "source_value",
			"title" => "title_value",
			"author" => "author_value",
			"description" => "description_value",
			"pages" => "value_pages",
			"article_title" => "article_title_value",
			"article_author" => "article_author_value",
			"barcode" => "barcode_value",
			"isbn" => "isbn_value",
			"issn" => "issn_value",
			"bib_number" => "bib_number_value",
			"adm_number" => "adm_number_value",
			"item_sequence" => "item_sequence_value",
			"call_number" => "call_number_value",
			"send_to" => "send_to_value",
			"rush" => "rush_value",
			"jtitle" => "jtitle_value",
			"request_date" => "1/1/2000 12:01PM -05:00",
			"SystemID" => "SystemID_value",
			"pickup" => "Hesburgh Library",
			"institution" => "University of Notre Dame",
	    "department" => "Chemical Engineering",
	    "user_status" => "Grad"
		}
	}
	let(:illiad_hash) {
		{
		   "source" => "transaction_value",
		   "send_to" => "send_to_value",
		   "month" => "month_value",
		   "issn" => "issn_value",
		   "author" => "author_value",
		   "adm_number" => "adm_number_value",
		   "issue" => "issue_value",
		   "UserName" => "UserName_value",
		   "request_type" => "request_type_value",
		   "transaction" => "transaction_value",
		   "isbn" => "isbn_value",
		   "article_title" => "article_title_value",
		   "TransactionStatus" => "TransactionStatus_value",
		   "location" => "location_value",
		   "volume" => "volume_value",
		   "rush" => "rush_value",
		   "barcode" => "barcode_value",
		   "jtitle" => "jtitle_value",
		   "SystemID" => "SystemID_value",
		   "article_author" => "article_author_value",
		   "item_sequence" => "item_sequence_value",
		   "pieces" => "pieces_value",
		   "bib_number" => "bib_number_value",
		   "title" => "title_value",
		   "delivery_type" => "delivery_type_value",
		   "year" => "year_value",
		   "pages" => "value_pages"
		}
	}
	let(:aleph_request) { Resource::Annex::Request.new(aleph_hash) }
	let(:illiad_request) { Resource::Annex::Request.new(illiad_hash) }

	describe "#description" do
		it "should use description if given" do
			expect(aleph_request.formatted_description).to eq("description_value p. value_pages")
		end

		it "should compose description if one is not given" do
			expect(illiad_request.formatted_description).to eq("volume_value: issue_value (year_value-month_value) p. value_pages; pieces: pieces_value")
		end

		it "should give (year) if month is missing" do
			hash = self.illiad_hash.except("month")
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("volume_value: issue_value (year_value) p. value_pages; pieces: pieces_value")
		end

		it "should give (month) if year is missing" do
			hash = self.illiad_hash.except("year")
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("volume_value: issue_value (month_value) p. value_pages; pieces: pieces_value")
		end

		it "should not put a colon in enumeration if volume is missing" do
			hash = self.illiad_hash.except("volume")
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("issue_value (year_value-month_value) p. value_pages; pieces: pieces_value")
		end

		it "should not put a colon in enumeration if issue is missing" do
			hash = self.illiad_hash.except("issue")
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("volume_value (year_value-month_value) p. value_pages; pieces: pieces_value")
		end

		it "should not put a p. if pages is missing" do
			hash = self.illiad_hash.except("pages")
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("volume_value: issue_value (year_value-month_value); pieces: pieces_value")
		end

		it "should not put a semicolon if pieces is missing" do
			hash = self.illiad_hash.except("pieces")
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("volume_value: issue_value (year_value-month_value) p. value_pages")
		end

		it "should not put a semicolon if pieces is there, but nothing else before it" do
			hash = self.illiad_hash.except("volume", "issue", "year", "month", "pages")
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("pieces: pieces_value")
		end

		it "should not put a p. in pages if a p is already there" do
			hash = self.aleph_hash
			hash["pages"] = "p. 343"
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("description_value p. 343")
		end

		it "should not put a p. in pages if a P is already there" do
			hash = self.aleph_hash
			hash["pages"] = "P. 343"
			expect(Resource::Annex::Request.new(hash).formatted_description).to eq("description_value P. 343")
		end
	end


	describe "#to_json" do

		let(:request_description) { aleph_request.formatted_description }
		let(:request_json) { {
			transaction: "source_value-transaction_value",
			request_date_time: "2000-01-01T12:01:00.000-05:00",
			request_type: "request_type_value",
			delivery_type: "delivery_type_value",
			source: "source_value",
			title: "title_value",
			author: "author_value",
			description: "description_value p. value_pages",
			pages: "value_pages",
			journal_title: "jtitle_value",
			article_title: "article_title_value",
			article_author: "article_author_value",
			barcode: "barcode_value",
			isbn_issn: "isbn_value",
			bib_number: "bib_number_value",
			adm_number: "adm_number_value",
			ill_system_id: "SystemID_value",
			item_sequence: "item_sequence_value",
			call_number: "call_number_value",
			send_to: "send_to_value",
			rush: "rush_value",
			patron_status: "Grad",
			patron_department: "Chemical Engineering",
			patron_institution: "University of Notre Dame",
			pickup_location: "Hesburgh Library",
			}.to_json }

		it "returns a correctly formatted json representation" do
			expect(JSON.parse(aleph_request.to_json)).to eq(JSON.parse(request_json))
		end

		context "latin1 characters" do
			let(:latin1_path) { Rails.root.join("spec/fixtures/aleph_data/outbound/illiad.874180.json") }
			let(:latin1_data) { File.read(latin1_path) }
			let(:latin1_hash) { JSON.parse(latin1_data) }
			let(:request) { described_class.new(latin1_hash) }

			it "has invalid data" do
				expect { latin1_hash.fetch("month").present? }.to raise_error(ArgumentError, "invalid byte sequence in UTF-8")
			end

			it "can fetch a value with invalid data" do
				expect(request.field_present(:month)).to eq(true)
				expect(request.send(:fetch, :month)).to eq("April''�May")
			end

			it "returns a json representation" do
				expect(request.as_json).to be_kind_of(Hash)
			end
		end
	end

	describe "transaction_number" do
		it "combines source and transaction" do
			aleph_hash["source"] = "Aleph"
			aleph_hash["transaction"] = "000367787"
			expect(aleph_request.transaction_number).to eq("aleph-000367787")
		end

		it "returns a blank string if source is blank" do
			aleph_hash["source"] = nil
			aleph_hash["transaction"] = "000367787"
			expect(aleph_request.transaction_number).to eq("")
		end

		it "returns a blank string if transaction is blank" do
			aleph_hash["source"] = "Aleph"
			aleph_hash["transaction"] = nil
			expect(aleph_request.transaction_number).to eq("")
		end
	end

	describe "bib_number" do
		it "pads with 0s" do
			aleph_hash["bib_number"] = "1"
			expect(aleph_request.bib_number).to eq("000000001")
		end

		it "returns a blank string if the value is blank" do
			aleph_hash["bib_number"] = nil
			expect(aleph_request.bib_number).to eq("")
		end
	end

	describe "adm_number" do
		it "pads with 0s" do
			aleph_hash["adm_number"] = "1"
			expect(aleph_request.adm_number).to eq("000000001")
		end

		it "returns a blank string if the value is blank" do
			aleph_hash["adm_number"] = nil
			expect(aleph_request.adm_number).to eq("")
		end
	end

	describe "item_sequence" do
		it "strips spaces, replaces .s and pads with 0s" do
			aleph_hash["item_sequence"] = "   57.0"
			expect(aleph_request.item_sequence).to eq("00570")
		end

		it "returns a blank string if the value is blank" do
			aleph_hash["item_sequence"] = nil
			expect(aleph_request.item_sequence).to eq("")
		end
	end

	describe "request_date" do
		it "returns a parsed date" do
			aleph_hash["request_date"] = "1/1/2000 12:00AM"
			expect(aleph_request.request_date).to eq(DateTime.parse("2000-01-01 00:00:00 UTC"))
		end

		it "returns a blank string if the value is blank" do
			aleph_hash["request_date"] = nil
			expect(aleph_request.request_date).to eq("")
		end
	end

	describe "isbn_issn" do
		it "returns the isbn if present" do
			aleph_hash["isbn"] = "isbn"
			expect(aleph_request.isbn_issn).to eq("isbn")
		end

		it "returns the issn if present" do
			aleph_hash["isbn"] = nil
			aleph_hash["issn"] = "issn"
			expect(aleph_request.isbn_issn).to eq("issn")
		end

		it "returns a blank string if both are blank" do
			aleph_hash["isbn"] = nil
			aleph_hash["issn"] = nil
			expect(aleph_request.isbn_issn).to eq("")
		end
	end

	{
		article_author: :article_author,
		article_title: :article_title,
		author: :author,
		call_number: :call_number,
		delivery_type: :delivery_type,
		journal_title: :jtitle,
		patron_status: :user_status,
		patron_department: :department,
		patron_institution: :institution,
		pickup_location: :pickup,
		request_type: :request_type,
		pages: :pages,
		send_to: :send_to,
		source: :source,
		system_id: :SystemID,
		title: :title,
	}.each do |field, original_field|
		describe field.to_s do
			it "returns the value of #{original_field}" do
				aleph_hash[original_field.to_s] = "#{original_field}_value"
				expect(aleph_request.send(field)).to eq("#{original_field}_value")
			end

			it "returns a blank string by default" do
				aleph_hash.delete(original_field.to_s)
				expect(aleph_request.send(field)).to eq("")
			end

			it "returns a blank string if the value is nil" do
				aleph_hash[original_field.to_s] = nil
				expect(aleph_request.send(field)).to eq("")
			end
		end
	end
end
