require 'spec_helper'
require 'faker'

describe Org::Organization do
  subject {  Org::Organization  }

  let(:staff_directory_org1) { {"unitID" => 1, "unitName" => Faker::Company.name} }
  let(:staff_directory_org2) { {"unitID" => 2, "unitName" => Faker::Company.name} }

  describe "creates org objects" do

    let(:org1) {subject.new('library', staff_directory_org1["unitID"])}
    let(:org2) {subject.new('library', staff_directory_org2["unitID"])}

    before (:each) do
      Org::OrgContactInformation.new

      org1.stub(:pull_from_staff_directory).and_return(staff_directory_org1)
      org1.build_org

      org2.stub(:pull_from_staff_directory).and_return(staff_directory_org2)
      org2.build_org
    end

    it "returns an instance of Organization" do
      org1.should be_an_instance_of(subject)
    end

    it "returns a valid instance" do
      org1.name.should eq(staff_directory_org1["unitName"])
    end

    it "returns all orgs by context" do
      subject.stub(:http_get).and_return( '[' + staff_directory_org1.to_json + ',' + staff_directory_org2.to_json + ']' )
      subject.should_receive(:http_get).exactly(1).times
      subject.all_orgs_by_context('library').count.should eq(2)
    end

  end


  describe :caching do

    it "caches directory entry using id", :caching => true do
      o = subject.new('library', staff_directory_org1["unitID"])
      o.stub(:pull_from_staff_directory).and_return(staff_directory_org1)
      o.should_receive(:pull_from_staff_directory).once
      o.build_org
      o.name.should eq(staff_directory_org1["unitName"])

      o_cached = subject.new('library', staff_directory_org1["unitID"])
      o_cached.stub(:pull_from_staff_directory).and_return(staff_directory_org2)
      o_cached.should_receive(:pull_from_staff_directory).exactly(0).times
      o_cached.build_org
      o_cached.name.should eq(staff_directory_org1["unitName"])
    end


    it "expires the staff directory cache", :caching => true do
      o = subject.new('library', staff_directory_org1["unitID"])
      o.stub(:pull_from_staff_directory).and_return(staff_directory_org1)
      o.should_receive(:pull_from_staff_directory).once
      o.build_org
      o.name.should eq(staff_directory_org1["unitName"])

      subject.expire_cache

      o_cached = subject.new('library', staff_directory_org1["unitID"])
      o_cached.stub(:pull_from_staff_directory).and_return(staff_directory_org2)
      o_cached.should_receive(:pull_from_staff_directory).once
      o_cached.build_org
      o_cached.name.should eq(staff_directory_org2["unitName"])
    end

    it "expires specific staff directory cache entry", :caching => true do
      o = subject.new('library', staff_directory_org1["unitID"])
      o.stub(:pull_from_staff_directory).and_return(staff_directory_org1)
      o.should_receive(:pull_from_staff_directory).once
      o.build_org
      o.name.should eq(staff_directory_org1["unitName"])

      subject.expire_individual_cache(o.directory_cache_key)

      o_cached = subject.new('library', staff_directory_org1["unitID"])
      o_cached.stub(:pull_from_staff_directory).and_return(staff_directory_org2)
      o_cached.should_receive(:pull_from_staff_directory).once
      o_cached.build_org
      o_cached.name.should eq(staff_directory_org2["unitName"])
    end

  end

end

