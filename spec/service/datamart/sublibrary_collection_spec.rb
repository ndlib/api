require 'spec_helper'

describe Datamart::SublibraryCollection do
  subject { Datamart::SublibraryCollection }

  describe :to_json do

    it "renders content in json" do
      sublibrary_collections = subject.new()
      expect(sublibrary_collections.respond_to?(:to_json)).to be_truthy
    end

  end


  describe :to_xml do

    it "renders content in xml" do
      sublibrary_collections = subject.new()
      expect(sublibrary_collections.respond_to?(:to_xml)).to be_truthy
    end
  
  end


  describe :caching do

    context :floorplan do
      it "caches the result for reoccuring params ", :caching => true do
        sublibrary_collections = subject.new()
        expect(sublibrary_collections).to receive(:all_sublibrary_collections).and_return("RESPONSE")
        expect(sublibrary_collections.retrieve_sublibrary_collections).to eq("RESPONSE") # prime the cache


        sublibrary_collections2 = subject.new()
        expect(sublibrary_collections2.retrieve_sublibrary_collections).to eq("RESPONSE")
      end


      it "releases the cache when it is expired ", :caching => true do
        sublibrary_collections = subject.new()
        expect(sublibrary_collections).to receive(:all_sublibrary_collections).and_return("RESPONSE")
        expect(sublibrary_collections.retrieve_sublibrary_collections).to eq("RESPONSE") # prime the cache

        subject.expire_cache

        sublibrary_collections2 = subject.new()
        expect(sublibrary_collections2).to receive(:all_sublibrary_collections).and_return("NEW RESPONSE")
        expect(sublibrary_collections2.retrieve_sublibrary_collections).to eq("NEW RESPONSE")
      end


    end
  end



  describe :cache_key do
    it "generates a key for a full request " do
      sublibrary_collections = subject.new()
      expect(sublibrary_collections.send(:cache_key)).to eq("datamart::sublibrarycollection-1")
    end
  end

end
