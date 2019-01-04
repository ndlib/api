require 'spec_helper'

describe Resource::Datamart::Item do

	before(:all) do
		DatabaseCleaner.strategy = :transaction
	end

	after(:all) do
		DatabaseCleaner.strategy = :truncation
	end

	let(:bib_record) { Resource::Datamart::BibRecord.new } 

	describe "bib_record attributes" do
		
		it "has a title" do
			expect(bib_record).to receive(:ttl_txt).and_return('This is the Title')
			expect(bib_record.title).to eq('This is the Title')
		end		

		it "has an author" do
			expect(bib_record).to receive(:authr_nm).and_return('Theodore Hesburgh')
			expect(bib_record.author).to eq('Theodore Hesburgh')
		end

		it "has an imprint" do
			expect(bib_record).to receive(:imprnt_txt).and_return('Notre Dame, Notre Dame 1975')
			expect(bib_record.imprint).to eq('Notre Dame, Notre Dame 1975')
		end

		it "has an edition" do
			expect(bib_record).to receive(:edtn_txt).and_return('First Edition')
			expect(bib_record.edition).to eq('First Edition')
		end

		it "has an isbn_issn" do
			expect(bib_record).to receive(:isbn_issn_txt).and_return('12345678')
			expect(bib_record.isbn_issn).to eq('12345678')
		end

	end

end