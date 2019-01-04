require 'spec_helper'
require 'faker'

describe Person::Base do
  let(:ldap_person1) { FactoryGirl.build(:ldap_entry) }
  let(:ldap_person2) { FactoryGirl.build(:ldap_entry) }
  let(:staff_directory_person1) { {"netID" => 'netid', "empID" => 1, "email" => Faker::Internet.user_name + '@nd.edu', "fname" => Faker::Name.first_name, "lname" => Faker::Name.last_name, "phone" => Faker::PhoneNumber.phone_number, "jobTitle" => Faker::Job.title} }
  let(:staff_directory_person2) { {"netID" => 'netid2', "empID" => 2, "email" => Faker::Internet.user_name + '@nd.edu', "fname" => Faker::Name.first_name, "lname" => Faker::Name.last_name, "phone" => Faker::PhoneNumber.phone_number, "jobTitle" => Faker::Job.title} }

  describe "compiles person objects from multiple sources" do
    let(:person1) {Person::Base.new('by_netid', ldap_person1.uid.first)}
    let(:person2) {Person::Base.new('by_netid', ldap_person2.uid.first)}
    before (:each) do
      person1.stub(:pull_from_ldap).and_return(ldap_person1)
      person1.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      person1.build_person(true)
      person2.stub(:pull_from_ldap).and_return(ldap_person2)
      person2.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      person2.build_person(true)
    end
    it "returns an instance of Person::Base" do
      person1.should be_an_instance_of(Person::Base)
    end
    it "returns a valid instance" do
      person1.netid.should eq(ldap_person1.uid.first)
      person1.first_name.should eq(staff_directory_person1["fname"])
      person1.last_name.should eq(staff_directory_person1["lname"])
    end
    it "returns all people by context" do
      Person::Base.stub(:http_get).and_return('[' + staff_directory_person1.to_json + ',' + staff_directory_person2.to_json + ']')
      Person::Base.should_receive(:http_get).exactly(3).times
      Person::Base.all_people_by_context('library').count.should eq(2)
    end
  end

  describe :caching do
    it "caches ldap response using netid", :caching => true do
      p = Person::Base.new('by_netid', ldap_person1.uid.first)
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.netid.should eq(ldap_person1.uid.first)

      p_cached = Person::Base.new('by_netid', ldap_person1.uid.first)
      p_cached.stub(:pull_from_ldap).and_return(ldap_person2)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p_cached.should_receive(:pull_from_ldap).exactly(0).times
      p_cached.build_person(true)
      p_cached.netid.should eq(ldap_person1.uid.first)
    end
    it "caches staff directory entry using netid", :caching => true do
      p = Person::Base.new('by_netid', ldap_person1.uid.first)
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.last_name.should eq(staff_directory_person1["lname"])

      p_cached = Person::Base.new('by_netid', ldap_person1.uid.first)
      p_cached.stub(:pull_from_ldap).and_return(ldap_person2)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p_cached.should_receive(:pull_from_staff_directory).exactly(0).times
      p_cached.build_person(true)
      p_cached.last_name.should eq(staff_directory_person1["lname"])
    end
    it "caches ldap response using id", :caching => true do
      p = Person::Base.new('by_id', staff_directory_person1["empID"])
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.last_name.should eq(staff_directory_person1["lname"])

      p_cached = Person::Base.new('by_id', staff_directory_person1["empID"])
      p_cached.stub(:pull_from_ldap).and_return(ldap_person2)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p_cached.should_receive(:pull_from_ldap).exactly(0).times
      p_cached.build_person(true)
      p_cached.last_name.should eq(staff_directory_person1["lname"])
    end
    it "caches staff directory entry using id", :caching => true do
      p = Person::Base.new('by_id', staff_directory_person1["empID"])
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.last_name.should eq(staff_directory_person1["lname"])

      p_cached = Person::Base.new('by_netid', staff_directory_person1["empID"])
      p_cached.stub(:pull_from_ldap).and_return(ldap_person2)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p_cached.should_receive(:pull_from_staff_directory).exactly(0).times
      p_cached.build_person(true)
      p_cached.last_name.should eq(staff_directory_person1["lname"])
    end
    it "expires the ldap cache", :caching => true do
      p = Person::Base.new('by_netid', ldap_person1.uid.first)
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.netid.should eq(ldap_person1.uid.first)

      Person::Base.expire_cache

      p_cached = Person::Base.new('by_netid', ldap_person1.uid.first)
      p_cached.stub(:pull_from_ldap).and_return(ldap_person2)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p_cached.should_receive(:pull_from_ldap).once
      p_cached.build_person(true)
      p_cached.netid.should eq(ldap_person2.uid.first)
    end
    it "expires the staff directory cache", :caching => true do
      p = Person::Base.new('by_netid', ldap_person1.uid.first)
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.last_name.should eq(staff_directory_person1["lname"])

      Person::Base.expire_cache

      p_cached = Person::Base.new('by_netid', ldap_person1.uid.first)
      p_cached.stub(:pull_from_ldap).and_return(ldap_person2)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p_cached.should_receive(:pull_from_staff_directory).once
      p_cached.build_person(true)
      p_cached.last_name.should eq(staff_directory_person2["lname"])
    end
    it "expires specific staff directory cache entry", :caching => true do
      p = Person::Base.new('by_netid', ldap_person1.uid.first)
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.last_name.should eq(staff_directory_person1["lname"])

      Person::Base.expire_individual_cache(p.send(:directory_cache_key))

      p_cached = Person::Base.new('by_netid', ldap_person1.uid.first)
      p_cached.stub(:pull_from_ldap).and_return(ldap_person2)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p_cached.should_receive(:pull_from_staff_directory).once
      p_cached.build_person(true)
      p_cached.last_name.should eq(staff_directory_person2["lname"])
    end
    it "returns appropriate data for different netids", :caching => true do
      p = Person::Base.new('by_netid', ldap_person1.uid.first)
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.last_name.should eq(staff_directory_person1["lname"])

      p2 = Person::Base.new('by_netid', ldap_person2.uid.first)
      p2.stub(:pull_from_ldap).and_return(ldap_person2)
      p2.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p2.should_receive(:pull_from_staff_directory).once
      p2.build_person(true)
      p2.last_name.should eq(staff_directory_person2["lname"])

      p_cached = Person::Base.new('by_netid', ldap_person1.uid.first)
      p_cached.stub(:pull_from_ldap).and_return(ldap_person1)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p_cached.should_receive(:pull_from_staff_directory).exactly(0).times
      p_cached.should_receive(:pull_from_ldap).exactly(0).times
      p_cached.build_person(true)
      p_cached.last_name.should eq(staff_directory_person1["lname"])
    end
    it "returns appropriate data for different ids", :caching => true do
      p = Person::Base.new('by_id', staff_directory_person1["empID"])
      p.stub(:pull_from_ldap).and_return(ldap_person1)
      p.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p.build_person(true)
      p.last_name.should eq(staff_directory_person1["lname"])

      p2 = Person::Base.new('by_id', staff_directory_person2["empID"])
      p2.stub(:pull_from_ldap).and_return(ldap_person2)
      p2.stub(:pull_from_staff_directory).and_return([staff_directory_person2])
      p2.should_receive(:pull_from_ldap).once
      p2.build_person(true)
      p2.last_name.should eq(staff_directory_person2["lname"])

      p_cached = Person::Base.new('by_id', staff_directory_person1["empID"])
      p_cached.stub(:pull_from_ldap).and_return(ldap_person1)
      p_cached.stub(:pull_from_staff_directory).and_return([staff_directory_person1])
      p_cached.should_receive(:pull_from_staff_directory).exactly(0).times
      p_cached.should_receive(:pull_from_ldap).exactly(0).times
      p_cached.build_person(true)
      p_cached.last_name.should eq(staff_directory_person1["lname"])
    end
  end

  describe :cache_key do
    it "generates valid ldap cache key based on netid", :caching => true do
      p = Person::Base.new('by_netid', ldap_person1.uid.first)
      p.send(:ldap_cache_key).should eq("ldap-person::base-1/#{ldap_person1.uid.first}")
    end
    it "generates valid staff directory cache key based on netid", :caching => true do
      p = Person::Base.new('by_netid', ldap_person1.uid.first)
      p.send(:directory_cache_key).should eq("directory-person::base-1/#{ldap_person1.uid.first}")
    end
    it "generates valid ldap cache key based on id", :caching => true do
      p = Person::Base.new('by_id', staff_directory_person1["empID"])
      p.send(:ldap_cache_key).should eq("ldap-person::base-1/#{staff_directory_person1['empID']}")
    end
    it "generates valid staff directory cache key based on id", :caching => true do
      p = Person::Base.new('by_id', staff_directory_person1["empID"])
      p.send(:directory_cache_key).should eq("directory-person::base-1/#{staff_directory_person1['empID']}")
    end
  end

end
