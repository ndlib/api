require 'spec_helper'

describe Resource::Datamart::Item do

  before(:all) do
    DatabaseCleaner.strategy = :transaction
  end

  after(:all) do
    DatabaseCleaner.strategy = :truncation
  end

  let(:item) { Resource::Datamart::Item.new } 
  let(:bibliographic_record) { Resource::Datamart::Item.new } 

  describe "item attributes" do

    it "has the barcode number" do
      expect(item).to receive(:brcde).and_return('123456789')
      expect(item.barcode).to eq('123456789')
    end	

    it "has the bibliographic id number" do
      expect(item).to receive(:doc_nbr).and_return('00765432')
      expect(item.bib_id).to eq('00765432')
    end	

    it "has the status number" do
      expect(item).to receive(:itm_status_cde).and_return('02')
      expect(item.status_number).to eq('02')
    end

    it "has the sequence number" do
      expect(item).to receive(:itm_seq_nbr).and_return('00012')
      expect(item.sequence_number).to eq('00012')
    end

    it "has the administrative document number" do
      expect(item).to receive(:adm_doc_nbr).and_return('9876543')
      expect(item.admin_document_number).to eq('9876543')
    end

    it "has the call number" do
      expect(item).to receive(:call_nbr).and_return('A 123 .B456 1991')
      expect(item.call_number).to eq('A 123 .B456 1991')
    end

    it "has the description" do
      expect(item).to receive(:dsc).and_return('vol. 25, 1991')
      expect(item.description).to eq('vol. 25, 1991')		
    end

    it "has an internal note" do
      expect(item).to receive(:note_intrnl).and_return('purchased 1991')
      expect(item.internal_note).to eq('purchased 1991')
    end

    it "has a bibliographic title" do
      expect(bibliographic_record).to receive(:title).and_return('This is the Title')
      expect(item).to receive(:bib_record).and_return(bibliographic_record)
      expect(item.bibliographic_title).to eq('This is the Title')
    end

    it "has a bibliographic author" do
      expect(bibliographic_record).to receive(:author).and_return('Some Author')
      expect(item).to receive(:bib_record).and_return(bibliographic_record)
      expect(item.bibliographic_author).to eq('Some Author')
    end

    it "has a bibliographic imprint" do
      expect(bibliographic_record).to receive(:imprint).and_return('Boston, MA 1956')
      expect(item).to receive(:bib_record).and_return(bibliographic_record)
      expect(item.bibliographic_imprint).to eq('Boston, MA 1956')
    end

    it "has a bibliographic edition" do
      expect(bibliographic_record).to receive(:edition).and_return('First Edition')
      expect(item).to receive(:bib_record).and_return(bibliographic_record)
      expect(item.bibliographic_edition).to eq('First Edition')
    end

    it "has a bibliographic isbn / issn" do
      expect(bibliographic_record).to receive(:isbn_issn).and_return('12345678')
      expect(item).to receive(:bib_record).and_return(bibliographic_record)
      expect(item.bibliographic_isbn_issn).to eq('12345678')
    end

    it "parses condition information" do
      expect(item).to receive(:note_intrnl).and_return('COVER-DET|COVER-TORN|NEEDS-ENCLS|PAGES-BRITTLE% ')
      expect(item.condition.count).to eq(4)	
    end

  end

end
