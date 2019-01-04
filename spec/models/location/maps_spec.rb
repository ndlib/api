require 'spec_helper'

describe Location::Maps do

  let(:floor_plan_request_partial) { { floor: '1st' } }
  let(:floor_plan_request_full) { { floor: '1st', library: 'hesburgh' } }
  let(:floor_plan_request_invalid_params) { { param: '23432434', floor: '2nd', invalid_key: 'asdfadfs', library: 'hesburgh' } }

  let(:call_number_request_partial) { { call_number: '523234234' } }
  let(:call_number_request_full) { { call_number: '523234234', collection: 'GEN', sublibrary: 'HESB' } }
  let(:call_number_request_invalid_params) { { param: '23432434', invalid_key: 'asdfadfs', call_number: '523234234', collection: 'GEN', sublibrary: 'HESB' } }

  describe :to_json do

    it "renders content in json" do
      maps = Location::Maps.new(floor_plan_request_full)
      maps.respond_to?(:to_json).should be_truthy
    end

  end


  describe :to_xml do
    it "renders content in xml" do
      maps = Location::Maps.new(floor_plan_request_full)
      maps.respond_to?(:to_xml).should be_truthy
    end

    it "adds a stack_maps tag" do
      Location::Maps.stub(:http_get).and_return({json: true}.to_json)

      maps = Location::Maps.new(floor_plan_request_full)
      maps.to_xml.include?('<stack_maps>').should be_truthy
    end

    it "adds a map tag" do
      Location::Maps.stub(:http_get).and_return({json: true}.to_json)

      maps = Location::Maps.new(floor_plan_request_full)
      maps.to_xml.include?('<map>').should be_truthy
    end
  end


  describe :caching do

    context :floorplan do
      it "caches the result for reoccuring params ", :caching => true do
        maps = Location::Maps.new(floor_plan_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache


        maps2 = Location::Maps.new(floor_plan_request_full)
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "RESPONSE"
      end


      it "releases the cache when it is expired ", :caching => true do
        maps = Location::Maps.new(floor_plan_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache

        Location::Maps.expire_cache

        maps2 = Location::Maps.new(floor_plan_request_full)
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "NEW RESPONSE"
      end


      it "caches a different response for floor ", :caching => true do
        maps = Location::Maps.new(floor_plan_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache

        maps2 = Location::Maps.new({ floor: '2nd', library: 'hesburgh' })
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "NEW RESPONSE"
      end


      it "caches a different response for library ", :caching => true do
        maps = Location::Maps.new(floor_plan_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache

        maps2 = Location::Maps.new({ floor: '1st', library: 'newlib' })
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "NEW RESPONSE"
      end
    end


    context :call_number do
      it "caches the result for reoccuring params ", :caching => true do
        maps = Location::Maps.new(call_number_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache

        maps2 = Location::Maps.new(call_number_request_full)
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "RESPONSE"
      end


      it "releases the cache when it is expired ", :caching => true do
        maps = Location::Maps.new(call_number_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache

        Location::Maps.expire_cache

        maps2 = Location::Maps.new(call_number_request_full)
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "NEW RESPONSE"
      end


      it "caches a different response for call_number ", :caching => true do
        maps = Location::Maps.new(call_number_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache

        maps2 = Location::Maps.new({ call_number: 'new_call_number', collection: 'GEN', sublibrary: 'HESB' } )
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "NEW RESPONSE"
      end

      it "caches a different response for collection ", :caching => true do
        maps = Location::Maps.new(call_number_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache

        maps2 = Location::Maps.new({ call_number: '523234234', collection: 'new', sublibrary: 'HESB' } )
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "NEW RESPONSE"
      end


      it "caches a different response for sublibrary ", :caching => true do
        maps = Location::Maps.new(call_number_request_full)
        Location::Maps.stub(:http_get).and_return("RESPONSE")
        maps.retrieve_maps.should == "RESPONSE" # prime the cache

        maps2 = Location::Maps.new({ call_number: '523234234', collection: 'GEN', sublibrary: 'new' } )
        Location::Maps.stub(:http_get).and_return("NEW RESPONSE")
        maps2.retrieve_maps.should == "NEW RESPONSE"
      end
    end
  end


  describe :cache_key do
    context :floorplan do
      it "generates a key for a partial request " do
        maps = Location::Maps.new(floor_plan_request_partial)
        maps.send(:cache_key).should == "location::maps-1/floor=1st"
      end


      it "generate a key for a full request" do
        maps = Location::Maps.new(floor_plan_request_full)
        maps.send(:cache_key).should == "location::maps-1/floor=1st&library=hesburgh"
      end
    end

    context :call_number do
      it "generates a key for a partial request " do
        maps = Location::Maps.new(call_number_request_partial)
        maps.send(:cache_key).should == "location::maps-1/call_number=523234234"
      end


      it "generate a key for a full request" do
        maps = Location::Maps.new(call_number_request_full)
        maps.send(:cache_key).should == "location::maps-1/call_number=523234234&collection=GEN&sublibrary=HESB"
      end
    end
  end


  describe :uri do
    context :floorplan do
      it "creates a partial request" do
        maps = Location::Maps.new(floor_plan_request_partial)
        maps.send(:uri).should == "http://test.host/utilities/maps/api.json?floor=1st"
      end

      it "creates a full request " do
        maps = Location::Maps.new(floor_plan_request_full)
        maps.send(:uri).should == "http://test.host/utilities/maps/api.json?floor=1st&library=hesburgh"
      end

      it "filters out invalid params" do
        maps = Location::Maps.new(floor_plan_request_invalid_params)
        maps.send(:uri).should == "http://test.host/utilities/maps/api.json?floor=2nd&library=hesburgh"
      end
    end
  end


  context :call_number do
      it "creates a partial request" do
        maps = Location::Maps.new(call_number_request_partial)
        maps.send(:uri).should == "http://test.host/utilities/maps/api.json?call_number=523234234"
      end

      it "creates a full request " do
        maps = Location::Maps.new(call_number_request_full)
        maps.send(:uri).should == "http://test.host/utilities/maps/api.json?call_number=523234234&collection=GEN&sublibrary=HESB"
      end

      it "filters out invalid params" do
        maps = Location::Maps.new(call_number_request_invalid_params)
        maps.send(:uri).should == "http://test.host/utilities/maps/api.json?call_number=523234234&collection=GEN&sublibrary=HESB"
      end
  end
end
