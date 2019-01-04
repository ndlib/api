FactoryGirl.define do
  sequence :consumer_name do |n|
    "Consumer#{n}"
  end

  factory :consumer, class: Admin::Consumer do

    name {generate(:consumer_name)}

  end
end
