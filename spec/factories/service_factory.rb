FactoryGirl.define do

  sequence :service_name do |n|
    "Service#{(0...3).map{ ('a'..'z').to_a[rand(26)] }.join}"
  end

  sequence :service_code do |n|
    "code#{n}"
  end


  factory :service, class: Admin::Service do
    name {generate(:service_name)}
    code {generate(:service_code)}
    service_class "Service"
    description "Description"
    parameters "Parameters"
    path "/api"
  end

end
