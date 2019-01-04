require 'spec_helper'

describe Aleph::HoldItem do

  describe "::initialize" do

    let(:item_record) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'item_record.rb')).read).to_ostruct }
    let(:no_bib_record) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bib_record_not_found.rb')).read).to_ostruct }

    context "without valid attributes" do
      subject { Aleph::HoldItem.new(no_bib_record) }

      it "is invalid sans required attributes" do
        expect(subject).to be_invalid
      end

    end

    context "with valid attributes" do
      subject { Aleph::HoldItem.new(item_record) }

      it "sets an item name" do
        expect(subject.item_description).to eq 'Bd.3'
      end

      it "sets an item number" do
        expect(subject.item_number).to eq 'BLD1231364$$$NDU01001600269$$$NDU50001600269000030'
      end

      it "sets the enumeration" do
        expect(subject.enumeration).to eq '3 22 1978'
      end

      it "sets the location" do
        expect(subject.location).to eq 'B 3185 .B257 1998'
      end

      it "sets the item collection" do
        expect(subject.collection).to eq 'General Collection'
      end

      it "sets the item bib id" do
        expect(subject.bib_id).to eq '001600269'
      end

      it "sets the hold request uri" do
        expect(subject.hold_request_uri).to eq 'http://paul.library.nd.edu:1891/rest-dlf/patron/BLD1231364/record/NDU01001600269/items/NDU50001600269000030/hold'
      end

    end

    context "when no bib record found" do
      subject { Aleph::HoldItem.new(no_bib_record) }

      it "returns response indicating no record" do
        expect(subject.full_response.reply_text).to eq 'Record does not exist'
      end

      it "will not have an item_description" do
        expect(subject.item_description).to be_nil
      end

      it "will not have a location" do
        expect(subject.location).to be_nil
      end
    end

  end

  describe "#pickup_locations" do
    let(:item_record) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'item_record.rb')).read).to_ostruct }

    context "with multiple pickup locations" do
      subject { Aleph::HoldItem.new(item_record) }

      it "lists the correct number of locations" do
        expect(subject.pickup_locations.count).to eq(10)
      end

      it "determines what the location codes are" do
        expect(subject.pickup_locations[0][:code]).to eq 'NDCAM'
      end

      it "provides a location label for each location" do
        expect(subject.pickup_locations[0][:content]).to eq 'Notre Dame Dept. Delivery'
      end
    end

  end

end
