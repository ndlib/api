require 'spec_helper'

describe Aleph::HoldRequest do

  subject { Aleph::HoldRequest.new('BLD12345678$$$NDU01000123456$$$NDU5000123456000010') }

  describe "::initialize" do

    context "without required parameters" do
       before(:each) do
        subject.patron_id = 'BLD12345678'
        subject.item_id = 'NDU5000123456000010'
        subject.record_id = 'NDU01000123456'
        subject.request_body = '<xml><request>TEST</request></xml>'
        subject.pickup_location = 'HESB'
      end

      it "fails to validate with missing patron id" do
        subject.patron_id = nil
        expect(subject.valid?).to be_falsey
      end

      it "fails to validate with missing item id" do
        subject.item_id = nil
        expect(subject.valid?).to be_falsey
      end

      it "fails to validate with missing record id" do
        subject.record_id = nil
        expect(subject.valid?).to be_falsey
      end

      it "defaults the start_interest_date" do
        expect(subject.start_interest_date).to eq(Date.today.strftime('%Y%m%d'))
      end

      it "defaults the last_interest_date" do
        expect(subject.last_interest_date).to eq(Date.today.since(6.months).strftime('%Y%m%d'))
      end

    end

    context "with required parameters" do

      it "instatiates a REST connection" do
        expect(subject.rest_connection).to be_a_kind_of(Aleph::REST)
      end

      it "sets the patron id" do
        expect(subject.patron_id).to eq 'BLD12345678'
      end

      it "sets the record id" do
        expect(subject.record_id).to eq 'NDU01000123456'
      end

      it "sets the item id" do
        expect(subject.item_id).to eq 'NDU5000123456000010'
      end

    end

  end

  describe "#valid_request?" do

    let(:invalid_request) { Aleph::HoldRequest.new('BLD12345678$$$NDU01000123456') }

    before(:each) do
      subject.patron_id = 'BLD12345678'
      subject.item_id = 'NDU5000123456000010'
      subject.record_id = 'NDU01000123456'
      subject.pickup_location = 'HESB'
    end

    it "returns false if discovery id is incorrect" do
      expect(invalid_request.valid_request?).to be_falsey
    end

    it "returns false if patron id is missing" do
      subject.patron_id = nil
      expect(subject.valid_request?).to be_falsey
    end

    it "returns false if item id is missing" do
      subject.item_id = nil
      expect(subject.valid_request?).to be_falsey
    end

    it "returns false if record id is missing" do
      subject.record_id = nil
      expect(subject.valid_request?).to be_falsey
    end

    it "returns false if last_interest_date is missing" do
      subject.last_interest_date = nil
      expect(subject.valid_request?).to be_falsey
    end

    it "returns false if start_interest_date is missing" do
      subject.start_interest_date = nil
      expect(subject.valid_request?).to be_falsey
    end

    it "returns false if pickup location is missing" do
      subject.pickup_location = nil
      expect(subject.valid_request?).to be_falsey
    end

    it "returns true if hold request is valid" do
      expect(subject.valid_request?).to be_truthy
    end

  end

  describe "#place_hold_request" do

    before(:each) do
      subject.last_interest_date = '20150815'
      subject.start_interest_date = '20150715'
      subject.note = 'Please rush!'
      subject.rush_flag = true
      subject.pickup_location = 'HESB'
    end

    context "without required parameters" do

      it "returns failure message" do
        subject.pickup_location = nil
        expect(subject.place_hold_request).to eq "request_body can't be blank"
      end

      it "indicates which attribute failed to validate" do
        subject.request_body = '<test></test>'
        subject.pickup_location = nil
        expect(subject.place_hold_request).to eq "pickup_location can't be blank"
      end

      it "indicates when the discovery id is invalid" do
        subject.request_body = '<test></test>'
        expect(subject).to receive(:discovery_id).and_return('BLD123$$NDU011111').at_least(:once)
        expect(subject.place_hold_request).to eq "Invalid discovery id submitted"
      end

      it 'fails when last_interest_date is not set' do
        subject.last_interest_date = nil
        expect(subject.place_hold_request).to eq("request_body can't be blank")
      end

      it 'fails when start_interest_date is not set' do
        subject.start_interest_date = nil
        expect(subject.place_hold_request).to eq("request_body can't be blank")
      end

    end

    context "when hold request succeeds" do

      it "sets the request body" do
        expect(subject.rest_connection).to receive(:transact).and_return("ok")
        subject.place_hold_request
        expect(subject.request_body).to include('<note-1>Please rush!</note-1>')
      end

      it "sets the correct request url" do
        expect(subject.rest_connection).to receive(:transact).and_return("ok")
        subject.place_hold_request
        expect(subject.rest_connection.path).to eq "/rest-dlf/patron/BLD12345678/record/NDU01000123456/items/NDU5000123456000010/hold"
      end

      it "sets the status message correctly" do
        expect(subject.rest_connection).to receive(:transact).and_return("ok")
        subject.place_hold_request
        expect(subject.request_status).to eq 'ok'
      end

    end

    context "when hold request fails" do

      it "returns failure message and sets status message" do
        expect(subject.rest_connection).to receive(:transact).and_return("Failed to create request")
        subject.place_hold_request
        expect(subject.request_status).to eq 'Failed to create request'
      end

    end

  end

end
