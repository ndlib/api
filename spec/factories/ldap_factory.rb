require 'faker'
require 'net-ldap'

FactoryGirl.define do
  
  factory :ldap_entry, class: Net::LDAP::Entry do 
    initialize_with {
      lde = new() 
      lde["ndtitle"] = Faker::Job.title
      lde["nddepartment"] = Faker::Lorem.words
      lde["uid"] = Faker::Internet.user_name
      lde["givenname"] = Faker::Name.first_name
      lde["sn"] = Faker::Name.last_name
      lde
    }
  end

end
