require 'spec_helper'

describe Location::Hours do
  subject { Location::Hours }

  describe :caching do

    it "caches hours response for the same codes and date", :caching => true  do
#      h = subject.new('code', '2012-1-1')
#      subject.stub(:http_get).and_return("RESPONSE")
#      h.retrieve_hours.should == "RESPONSE" # prime the cache

#      h2 = subject.new('code', '2012-1-1')
#      Hours.stub(:http_get).and_return("NEW RESPONSE")
#      h2.retrieve_hours.should == "RESPONSE"
    end


    it "releases the cache when it is expired ", :caching => true do
      h = subject.new('code', '2012-1-1')
      subject.stub(:http_get).and_return("RESPONSE")
      h.retrieve_hours.should == "RESPONSE" # prime the cache

      subject.expire_cache

      h2 = subject.new('code', '2012-1-1')
      subject.stub(:http_get).and_return("NEW RESPONSE")
      h2.retrieve_hours.should == "NEW RESPONSE"
    end


    it "caches a different response for each day ", :caching => true do
      h = subject.new('code', '2012-1-1')
      subject.stub(:http_get).and_return("RESPONSE")
      h.retrieve_hours.should == "RESPONSE" # prime the cache

      h2 = subject.new('code', '2012-1-2')
      subject.stub(:http_get).and_return("NEW RESPONSE")
      h2.retrieve_hours.should == "NEW RESPONSE"
    end


    it "caches a different response for different codes", :caching => true do
      h = subject.new('code', '2012-1-1')
      subject.stub(:http_get).and_return("RESPONSE")
      h.retrieve_hours.should == "RESPONSE" # prime the cache

      h2 = subject.new('code2', '2012-1-1')
      subject.stub(:http_get).and_return("NEW RESPONSE")
      h2.retrieve_hours.should == "NEW RESPONSE"
    end
  end


  describe :cache_key do

    it "generates cache key" do
      h = subject.new('code', "2012-11-11")
      h.cache_key.should == "location::hours-1/code-2012-11-11"
    end

    it "subs removes spaces" do
      h = subject.new('c o d e', "2012-11-11")
      h.cache_key.should == "location::hours-1/code-2012-11-11"
    end

    it "has multiple codes represented" do
      h = subject.new('code,code1', '2012-11-11')
      h.cache_key.should == "location::hours-1/code,code1-2012-11-11"
    end

    it "allows for no code to be passed" do
      h = subject.new('', '2012-11-11')
      h.cache_key.should == "location::hours-1/-2012-11-11"
    end

    it "defaults to today for no passed date" do
      h = subject.new("code", "")
      h.cache_key.should == "location::hours-1/code-#{Date.today.to_s(:db)}"
    end
  end


  describe :uri do
    it "generates a correct uri from the codes and date" do
      h = subject.new('code', "2012-11-11")
      h.send(:uri).should == "http://test.host/utilities/availability/hours/api?codes=code&date=2012-11-11"
    end
  end


end
