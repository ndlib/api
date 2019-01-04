require 'spec_helper'

class Class1 
  include CacheHelper
end

class Class2
  include CacheHelper
end


describe CacheHelper do

  describe "base_cache_key" do
 
    it "inspects the class name to make the base key", :caching => true  do
      Class1.base_cache_key.should == "class1-1"
      Class2.base_cache_key.should == "class2-1"
    end 
       
  end

  describe "#expire_cache" do
    
    it "clearing the cache increments the namespaced counter", :caching => true do
      Class1.base_cache_key.should == "class1-1"
      Class1.expire_cache
      Class1.base_cache_key.should == "class1-2"
    end

    it "does not share the increment number between different classes", :caching => true do
      Class1.expire_cache
      Class1.base_cache_key.should == "class1-2"
      Class2.base_cache_key.should == "class2-1"
    end

  end



end