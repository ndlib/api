require 'spec_helper'

describe Aleph::Item do

  describe "::initialize" do

    let(:item_record) { double("Resource::Datamart::Item",
      barcode: '00000007509490',
      bib_id: '820336',
      sequence_number: '10',
      admin_document_number: '98765')}
    let(:aleph_item) { Aleph::Item.new(item_record.barcode)}

    before(:each) do
      expect(Resource::Datamart::Item).to receive(:by_barcode).and_return(item_record)
    end

    it "sets the barcode" do
      expect(aleph_item.barcode).to eq('00000007509490')
    end

    it "sets the sequence number" do
      expect(aleph_item.sequence_number).to eq('00010')
    end

    it "sets the bib id" do
      expect(aleph_item.bib_id).to eq('000820336')
    end

    it "sets the administrative document number" do
      expect(aleph_item.administrative_document_number).to eq('000098765')
    end

  end

  describe "#retrieve_record" do
    let(:aleph_item_record) { Hash.from_xml(File.open(Rails.root.join('spec', 'fixtures', 'aleph_item.xml'))).to_ostruct }
    let(:item_record) { double("Resource::Datamart::Item",
      barcode: '00000007509490',
      bib_id: '820336',
      sequence_number: '10',
      admin_document_number: '98765')}
    let(:aleph_item) { Aleph::Item.new(item_record.barcode)}

    before(:each) do
      expect(Resource::Datamart::Item).to receive(:by_barcode).with('00000007509490').and_return(item_record)
      rest_connection = instance_double(ExternalRest)
      expect(aleph_item).to receive(:rest_connection).and_return(rest_connection)
      expect(rest_connection).to receive(:transact).and_return(aleph_item_record)
    end

    it "should parse the Aleph item record" do
      expect(aleph_item.retrieve_record.z30_sub_library).to eq('Hesburgh Library')
    end

    it "should parse the process status" do
      expect(aleph_item.retrieve_record.z30_item_process_status).to be_blank
    end
  end

  describe "#update_process_status" do
    let(:aleph_item_record) { Hash.from_xml(File.open(Rails.root.join('spec', 'fixtures', 'aleph_item.xml'))).to_ostruct }
    let(:aleph_updated_item_record) { Hash.from_xml(File.open(Rails.root.join('spec', 'fixtures', 'aleph_item_updated.xml'))).to_ostruct }
    let(:item_record) { double("Resource::Datamart::Item",
      barcode: '00000007509490',
      bib_id: '820336',
      sequence_number: '10',
      admin_document_number: '98765')}
    let(:aleph_item) { Aleph::Item.new(item_record.barcode)}
    let(:request_body) { 'op=update-item&library=NDU50&user_name=TESTUSER&user_password=TESTPASSWORD&xml_full_req=<update-item><z30><z30-doc-number>000098765</z30-doc-number><z30-item-sequence>00010</z30-item-sequence><z30-item-process-status>AT</z30-item-process-status></z30></update-item>' }
    let(:request_body2) { 'op=update-item&library=NDU50&user_name=TESTUSER&user_password=TESTPASSWORD&xml_full_req=<update-item><z30><z30-doc-number>000098765</z30-doc-number><z30-item-sequence>00010</z30-item-sequence><z30-item-process-status></z30-item-process-status></z30></update-item>' }
    let(:rest_connection) { instance_double(ExternalRest) }

    before(:each) do
      expect(Resource::Datamart::Item).to receive(:by_barcode).with('00000007509490').and_return(item_record)
      expect(aleph_item).to receive(:rest_connection).and_return(rest_connection).at_most(3).times
      expect(rest_connection).to receive(:verb=).with('post')
      expect(rest_connection).to receive(:transact).and_return(aleph_updated_item_record)
    end

    it "should build a correctly formatted updated item record xml" do
      expect(rest_connection).to receive(:payload=).with(request_body)
      aleph_item.update_process_status('AT')
      expect(aleph_item.send(:process_status_xml)).to eq('<update-item><z30><z30-doc-number>000098765</z30-doc-number><z30-item-sequence>00010</z30-item-sequence><z30-item-process-status>AT</z30-item-process-status></z30></update-item>')
    end

    it "should build a valid request body" do
      expect(rest_connection).to receive(:payload=).with(request_body)
      aleph_item.update_process_status('AT')
      expect(aleph_item.send(:request_body)).to eq(request_body)
    end

    it "should null out the process status when requested" do
      expect(rest_connection).to receive(:payload=).with(request_body2)
      aleph_item.update_process_status('')
      expect(aleph_item.send(:process_status_xml)).to eq('<update-item><z30><z30-doc-number>000098765</z30-doc-number><z30-item-sequence>00010</z30-item-sequence><z30-item-process-status></z30-item-process-status></z30></update-item>')
    end

    it "should return a record that has the updated process status" do
      expect(rest_connection).to receive(:payload=).with(request_body)
      aleph_item.update_process_status('AT')
      expect(aleph_item.process_status).to eq('AT')
    end

  end

  describe "#to_json" do
    let(:item_record) {
      double(
        "Resource::Datamart::Item",
        barcode: '00000007509490',
        bib_id: '820336',
        sequence_number: '10',
        admin_document_number: '98765',
        call_number: 'A 123 .C456',
        description: 'v. 7',
        bibliographic_title: 'The Title',
        bibliographic_author: 'Smith, Joe',
        bibliographic_imprint: 'Boston, MA 1976',
        bibliographic_edition: 'First Edition',
        bibliographic_isbn_issn: '12345',
        condition: ['TORN','WRIPPED'],
        sublibrary: "annex",
      )
    }
    let(:aleph_item) { Aleph::Item.new(item_record.barcode)}
    let(:aleph_json_record) {
      {
        item_id: "#{aleph_item.id}",
        barcode: "00000007509490",
        bib_id: "000820336",
        sequence_number: "00010",
        admin_document_number: "000098765",
        call_number: "A 123 .C456",
        description: "v. 7",
        title: 'The Title',
        author: 'Smith, Joe',
        publication: 'Boston, MA 1976',
        edition: 'First Edition',
        isbn_issn: '12345',
        condition: ["TORN","WRIPPED"],
        sublibrary: "annex",
      }
    }

    before(:each) do
      expect(Resource::Datamart::Item).to receive(:by_barcode).and_return(item_record)
    end

    it "bulds a complete json formatted item record" do
      expect(aleph_item.to_json).to eq(aleph_json_record.to_json)
    end

  end

end
