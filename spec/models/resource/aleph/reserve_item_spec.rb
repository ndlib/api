require 'spec_helper'

describe Resource::Aleph::ReserveItem do

  describe "complete item list" do

    let(:complete_physical_item_list) do
      complete_list = nil
      VCR.use_cassette('aleph/complete_reserve_item_list') do
        complete_list = described_class.all_aleph_reserves
      end
      complete_list
    end

    let(:first) { complete_physical_item_list.first }

    it "returns the complete list of items on physical reserve" do
        expect(complete_physical_item_list.count).to be == 512
    end

    it "returns the title of a reserve item" do
      expect(first[:title]).to eq "Gerald D. Schmidt & Larry S. Roberts' Foundations of parasitology"
    end

    it "returns the course triple a reserve item" do
      expect(first[:course_triple]).to eq "201820_BIOS_46497"
    end

    it "returns the course crosslist id" do
      expect(first[:crosslist_id]).to eq "201820_25773"
    end

    it "returns the course document number" do
      expect(first[:doc_number]).to eq "000068368"
    end

  end

  describe "retrieve section group id" do

    let(:section_group_return_value) do
      section_group_array = nil
      VCR.use_cassette('aleph/section_group_lookup') do
        section_group_array = described_class.find_section_group("201310_IIPS_60219", 1)
      end
      section_group_array
    end

    # The following is commented out because we are switching to Github Actions
    # and GA does not run in a whitelisted network.
    it "returns the section group id" do
      # section_group_return_value[0].should eq "201310_16203"
    end

    it "returns the crosslist id" do
      # section_group_return_value[1].should eq "201310_PQ"
    end

  end

  describe "sunspot search" do

    it "should return a sunpot search object" do
      described_class.sunspot_search(described_class).class.should eq Sunspot::Search::StandardSearch
    end

    it "should return the proper class context" do
      described_class.sunspot_search(described_class).query.scope.to_params[:fq][0].should eq "type:Resource\\:\\:Aleph\\:\\:ReserveItem"
    end

  end

  describe "real time availability information" do

    let(:rta_list) do
      rta = nil
      VCR.use_cassette('aleph/rta_lookup') do
        rta = described_class.item_status_by_doc_number('000049115')
      end
      rta
    end

    it "should return an accurate item list" do
      rta_list.count.should eq 3
    end

    it "should provide the item level status" do
      rta_list[1]['current_status'].should eq 'checked out'
    end

    it "should have value for due date if item is not available" do
      rta_list[1]['due_date'].blank?.should be_falsey
    end

    it "should provide the loan type" do
      rta_list[1]['loan_type'].should eq ''
      # empty being all
    end

    it "should provide the primary location" do
      rta_list[1]['primary_location'].should eq 'General Collection'
    end

    it "should provide the secondary location" do
      rta_list[1]['secondary_location'].should eq 'Hesburgh Library'
    end

  end

end
