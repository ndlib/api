# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :user, class: Admin::User do |u|
    u.name "MyString"
    u.sequence(:username) { |n| "username#{n}" }
  end
end
