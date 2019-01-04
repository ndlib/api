require 'spec_helper'

describe Aleph::HoldList do

  def connection_stubs
    Faraday::Adapter::Test::Stubs.new do |stub|
    end
  end

  describe "::initialize" do

    context "without valid attributes" do
      subject { Aleph::HoldList.new('12345') }

      it "will raise error when system id param is nil" do
        subject.system_id_list = nil
        expect{subject.valid?}.to raise_error("Institutional id list parameter must have at least one value")
      end

      it "will raise error without one or more institutional system ids" do
        expect{subject.valid?}.to raise_error("Institutional id list parameter must have at least one value")
      end

      it "will raise error without institutional id strings" do
        subject.system_id_list = [12345]
        expect{subject.valid?}.to raise_error("Institutional id cannot contain non-string values")
      end

      it "will raise error without a patron id" do
        subject.patron_id = nil
        subject.system_id_list = ['abd123']
        expect{subject.valid?}.to raise_error("Patron can't be blank")
      end

    end

    context "when initialized" do
      subject { Aleph::HoldList.new(['ndu_aleph001383987', 'bci_aleph000058148'], '12345') }

      it "will have a cache key" do
        expect(subject.cache_key).to eq '12345-ndu_aleph001383987-bci_aleph000058148'
      end

      it "will be valid with correct input params" do
        expect(subject.valid?).to be_truthy
      end

    end

  end

  describe "#populate_raw_item_list" do

    context "single volume" do
      let(:ndu_hold_list) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'nd_hold_list_1.rb')).read).to_ostruct.hold_grp_list }
      let(:bci_hold_list) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_hold_list_1.rb')).read).to_ostruct.hold_grp_list }
      let(:ndu_item) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'nd_item_1.rb')).read).to_ostruct }
      let(:bci_item) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_item_1.rb')).read).to_ostruct }
      let(:faraday_connection) { aleph_rest_connection { connection_stubs } }
      let(:aleph_rest) { Aleph::REST.new }
      subject { Aleph::HoldList.new(['ndu_aleph001383987', 'bci_aleph000058148'], 'BLD1231364') }

      before (:each) do
        aleph_rest.stub(:connection_instance).and_return(faraday_connection)
        subject.stub(:rest_api).and_return(aleph_rest)
      end

      def set_up_single_volume_data_pull
        expect(subject).to receive(:retrieve_list).twice.and_return(ndu_hold_list, bci_hold_list)
        expect(subject).to receive(:retrieve_item).twice.and_return(ndu_item, bci_item)
        subject.populate_raw_item_list
      end

      it "should return a group of one volume per institution" do
        set_up_single_volume_data_pull
        expect(subject.raw_item_list.count).to eq subject.raw_item_list.keys.count
      end

      it "should belong to a specific number of institutions" do
        set_up_single_volume_data_pull
        expect(subject.raw_item_list.keys.count).to eq(2)
      end

      it "should have one unique item" do
        set_up_single_volume_data_pull
        expect(subject.unique_items.count).to eq(1)
      end

    end

    context "multivolume" do
      let(:ndu_multivolume_hold_list) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'nd_multivolume_hold_list_1.rb')).read).to_ostruct.hold_grp_list }
      let(:bci_multivolume_hold_list) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_hold_list_1.rb')).read).to_ostruct.hold_grp_list }
      let(:ndu_multivolume_item_1) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'nd_multivolume_item_1.rb')).read).to_ostruct }
      let(:bci_multivolume_item_1) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_1.rb')).read).to_ostruct }
      let(:bci_multivolume_item_2) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_2.rb')).read).to_ostruct }
      let(:bci_multivolume_item_3) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_3.rb')).read).to_ostruct }
      let(:bci_multivolume_item_4) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_4.rb')).read).to_ostruct }
      let(:bci_multivolume_item_5) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_5.rb')).read).to_ostruct }
      let(:bci_multivolume_item_6) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_6.rb')).read).to_ostruct }
      let(:bci_multivolume_item_7) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_7.rb')).read).to_ostruct }
      let(:bci_multivolume_item_8) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_8.rb')).read).to_ostruct }
      let(:bci_multivolume_item_9) { eval(File.open(Rails.root.join('spec', 'fixtures', 'aleph_data', 'bci_multivolume_item_9.rb')).read).to_ostruct }
      let(:faraday_connection) { aleph_rest_connection { connection_stubs } }
      let(:aleph_rest) { Aleph::REST.new }
      subject { Aleph::HoldList.new(['ndu_aleph001526576', 'bci_aleph000136357'], 'BLD1231364') }

      before (:each) do
        aleph_rest.stub(:connection_instance).and_return(faraday_connection)
        subject.stub(:rest_api).and_return(aleph_rest)
      end

      def set_up_multivolume_data_pull
        expect(subject).to receive(:retrieve_list).twice.and_return(ndu_multivolume_hold_list, bci_multivolume_hold_list)
        expect(subject).to receive(:retrieve_item).exactly(10).times.and_return(ndu_multivolume_item_1, bci_multivolume_item_1, bci_multivolume_item_2, bci_multivolume_item_3, bci_multivolume_item_4, bci_multivolume_item_5, bci_multivolume_item_6, bci_multivolume_item_7, bci_multivolume_item_8, bci_multivolume_item_9)
        subject.populate_raw_item_list
      end

      it "should return a group of one volume per institution" do
        set_up_multivolume_data_pull
        expect(subject.raw_item_list.values.flatten.count).to eq(10)
      end

      it "should belong to a specific number of institutions" do
        set_up_multivolume_data_pull
        expect(subject.raw_item_list.keys.count).to eq(2)
      end

      it "should have the correct number of unique items" do
        set_up_multivolume_data_pull
        expect(subject.unique_items.count).to eq(9)
      end

      describe '#volumes' do
        let(:unique_items) do
          {
            "37"=>{:description=>"v.37 (2004)", :enumeration=>"37", :sort_order=>"37"},
            "9/10"=>{:description=>"v.9/10 (June 1975/May 1976)", :enumeration=>"9/10", :sort_order=>"9/10"},
            "22"=>{:description=>"v.22 (Jan./June 1988)", :enumeration=>"22", :sort_order=>"22"},
            "10"=>{:description=>"v.10 (June/Dec. 1976)", :enumeration=>"10", :sort_order=>"10"},
            "1"=>{:description=>"v.1 (May 1967/May 1968)", :enumeration=>"1", :sort_order=>"1"}
          }
        end

        before do
          subject.stub(:unique_items).and_return(unique_items)
        end

        it "is the sorted volumes" do
          expect(subject.volumes).to eq(
            [
              {:description=>"v.1 (May 1967/May 1968)", :enumeration=>"1", :sort_order=>"1"},
              {:description=>"v.9/10 (June 1975/May 1976)", :enumeration=>"9/10", :sort_order=>"9/10"},
              {:description=>"v.10 (June/Dec. 1976)", :enumeration=>"10", :sort_order=>"10"},
              {:description=>"v.22 (Jan./June 1988)", :enumeration=>"22", :sort_order=>"22"},
              {:description=>"v.37 (2004)", :enumeration=>"37", :sort_order=>"37"}
            ]
          )
        end
      end

    end

  end

end
