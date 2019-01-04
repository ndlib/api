require 'faker'

FactoryGirl.define do
  
  factory :person, :class => 'Person::Base' do |p|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    p.netid { Faker::Internet.user_name }
    p.first_name { first_name }
    p.last_name { last_name }
    p.position_title { Faker::Job.title }
    p.full_name first_name + ' ' + last_name
  end

end
