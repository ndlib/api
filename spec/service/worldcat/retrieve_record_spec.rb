require 'spec_helper'

describe Worldcat::RetrieveRecord do

  describe "::initialize" do

    context "without valid attributes" do
      subject { Worldcat::RetrieveRecord.new(nil, nil) }

      it "is invalid sans required attributes" do
        expect(subject).to be_invalid
      end

    end

    context "with valid attributes" do
      subject { Worldcat::RetrieveRecord.new('isbn', 12345) }

      it "should set the id type" do
        expect(subject.id_type).to eq 'isbn'
      end

      it "should set the record id" do
        expect(subject.record_id).to eq 12345
      end

      it "should set the base url" do
        expect(subject.base_url).to eq 'http://www.worldcat.org/webservices/catalog/content/libraries/isbn/12345'
      end

      it "should set the url path" do
        expect(subject.url_path).to eq '?libtype=1&maximumLibraries=1&format=json&location=46556&wskey=' + Application::Secrets::worldcat_api_key
      end

    end
  end

  describe "#fetch_record" do
    subject { Worldcat::RetrieveRecord.new('isbn', '12345') }
    wc_not_found_json = eval(%q(File.open(Rails.root.join('spec', 'fixtures', 'worldcat_isbn_record_not_found.json')).read))
    wc_found_json = eval(%q(File.open(Rails.root.join('spec', 'fixtures', 'worldcat_isbn_0815328702.json')).read))
    let(:record_not_found) { JSON.parse(wc_not_found_json).to_ostruct }
    let(:record_found) { JSON.parse(wc_found_json).to_ostruct }

    context "when record not found" do

      before(:each) do
        expect(subject.rest_connection).to receive(:transact).and_return(record_not_found)
        subject.fetch_record
      end

      it "will set the retrieved record to a not found symbol" do
        expect(subject.retrieved_record).to eq :not_found
      end

      it "will set the status message to indicate record not found" do
        expect(subject.status_message).to eq 'Record does not exist'
      end

    end

    context "when there is an error retrieving the record" do

      before(:each) do
        subject.fetch_record
      end

      it "will set the retrieved record to error symbol" do
        expect(subject.retrieved_record).to eq :error_retrieving_record
      end

      it "will set the status message to indicate that there was an error" do
        expect(subject.status_message).to include('Error retrieving record')
      end

    end

    context "when record found" do

      before(:each) do
        expect(subject.rest_connection).to receive(:transact).and_return(record_found)
        subject.fetch_record
      end

      it "will return a record with a title" do
        expect(subject.retrieved_record.title).to eq 'Popular culture and critical pedagogy : reading, constructing, connecting'
      end

      it "will return a record with one holding library" do
        expect(subject.retrieved_record.library.count).to eq 1
      end

      it "will return a record with a link back to the OPAC" do
        expect(subject.retrieved_record.library[0].opacUrl).to eq 'http://www.worldcat.org/wcpa/oclc/39275734?page=frame&url=http%3A%2F%2Flibrary.nd.edu%2Futilities%2Fsearch%2Fndu%2Fnd_campus%3Fq%3D0815328702+%26checksum%3Dbfdf2c361a09aa81609530eab80b41f7&title=University+of+Notre+Dame&linktype=opac&detail=IND%3AUniversity+of+Notre+Dame%3AARL Library&app=wcapi&id=IND-'
      end

      it "will set the status message to indicate record found" do
        expect(subject.status_message).to eq 'Record found'
      end

    end

  end

  describe "#to_json" do
    subject { Worldcat::RetrieveRecord.new('isbn', '12345') }
    wc_not_found_json = eval(%q(File.open(Rails.root.join('spec', 'fixtures', 'worldcat_isbn_record_not_found.json')).read))
    wc_found_json = eval(%q(File.open(Rails.root.join('spec', 'fixtures', 'worldcat_isbn_0815328702.json')).read))
    let(:record_not_found) { JSON.parse(wc_not_found_json).to_ostruct }
    let(:record_found) { JSON.parse(wc_found_json).to_ostruct }

    context "when a valid record is retrieved" do

      before(:each) do
        expect(subject.rest_connection).to receive(:transact).and_return(record_found)
        subject.fetch_record
      end

      it "serializes record into json" do
        expect(subject.to_json).to eq "{\"record\":{\"title\":\"Popular culture and critical pedagogy : reading, constructing, connecting\",\"author\":\"Daspit, Toby. Weaver, John A.\",\"publisher\":\"Garland Pub.\",\"nd_owned\":true,\"opac_url\":\"http://www.worldcat.org/wcpa/oclc/39275734?page=frame\\u0026url=http%3A%2F%2Flibrary.nd.edu%2Futilities%2Fsearch%2Fndu%2Fnd_campus%3Fq%3D0815328702+%26checksum%3Dbfdf2c361a09aa81609530eab80b41f7\\u0026title=University+of+Notre+Dame\\u0026linktype=opac\\u0026detail=IND%3AUniversity+of+Notre+Dame%3AARL Library\\u0026app=wcapi\\u0026id=IND-\"}}"
      end

      it "provides basic bibliographic information" do
        expect(JSON.parse(subject.to_json)['record']['title']).to eq "Popular culture and critical pedagogy : reading, constructing, connecting"
        expect(JSON.parse(subject.to_json)['record']['publisher']).to eq "Garland Pub."
      end

      it "provides an ND ownership flag" do
        expect(JSON.parse(subject.to_json)['record']['nd_owned']).to eq true
      end

      it "provides a link back to institutional OPAC" do
        expect(JSON.parse(subject.to_json)['record']['opac_url']).to eq 'http://www.worldcat.org/wcpa/oclc/39275734?page=frame&url=http%3A%2F%2Flibrary.nd.edu%2Futilities%2Fsearch%2Fndu%2Fnd_campus%3Fq%3D0815328702+%26checksum%3Dbfdf2c361a09aa81609530eab80b41f7&title=University+of+Notre+Dame&linktype=opac&detail=IND%3AUniversity+of+Notre+Dame%3AARL Library&app=wcapi&id=IND-'
      end

    end

    context "when there is an error or no record found" do

      it "reports no record found" do
        expect(subject.rest_connection).to receive(:transact).and_return(record_not_found)
        subject.fetch_record
        expect(JSON.parse(subject.to_json)['record']['status']).to eq 'Record not found'
      end

      it "provides a useful message when exception encountered" do
        expect(subject.rest_connection).to receive(:transact).and_raise('an error')
        subject.fetch_record
        expect(JSON.parse(subject.to_json)['record']['status']).to eq 'Error retrieving record - please see logs for details'
      end

    end
  end

end
