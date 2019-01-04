require 'spec_helper'

describe Datamart::Sublibrary do
  subject { Datamart::Sublibrary }

  describe :to_json do
    before(:each) do
      Datamart::Sublibrary.any_instance.stub(:retrieve_sublibraries).and_return([ double("Resource::Datamart::Sublibrary", code: 'HESBDSC')])
    end

    it "renders content in json" do
      sublibraries = subject.new()
      sublibraries.respond_to?(:to_json).should be_truthy
    end

  end

  describe :to_xml do
    before(:each) do
      subject.any_instance.stub(:retrieve_sublibraries).and_return([ double("Resource::Datamart::Sublibrary", code: 'HESBDSC')])
    end

    it "renders content in xml" do
      sublibraries = subject.new()
      sublibraries.respond_to?(:to_xml).should be_truthy
    end

    it "adds a sublibraries tag" do
      sublibraries = subject.new()
      sublibraries.to_xml.include?('<sublibraries type="array">').should be_truthy
    end
  end

  describe :caching do

    context :floorplan do
      it "caches the result for reoccuring params ", :caching => true do
        sublibraries = subject.new()
        sublibraries.stub(:all_sublibraries).and_return("RESPONSE")
        sublibraries.retrieve_sublibraries.should == "RESPONSE" # prime the cache


        sublibraries2 = subject.new()
        sublibraries2.stub(:all_sublibraries).and_return("NEW RESPONSE")
        sublibraries2.retrieve_sublibraries.should == "RESPONSE"
      end


      it "releases the cache when it is expired ", :caching => true do
        sublibraries = subject.new()
        sublibraries.stub(:all_sublibraries).and_return("RESPONSE")
        sublibraries.retrieve_sublibraries.should == "RESPONSE" # prime the cache

        subject.expire_cache

        sublibraries2 = subject.new()
        sublibraries2.stub(:all_sublibraries).and_return("NEW RESPONSE")
        sublibraries2.retrieve_sublibraries.should == "NEW RESPONSE"
      end


    end
  end

  describe :cache_key do
    it "generates a key for a full request " do
      sublibraries = subject.new()
      sublibraries.send(:cache_key).should == "datamart::sublibrary-1"
    end
  end

end
