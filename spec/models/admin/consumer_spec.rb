require 'spec_helper'

describe Admin::Consumer do

  let(:consumer) { FactoryGirl.create(:consumer) }
  let(:service)  { FactoryGirl.create(:service) }

  it "has associations to the service model" do
    consumer.methods.include?(:services).should be_truthy
  end


  it "can have services added to it" do
    c = consumer
    s = service

    c.services << s
    c.save!

    c.reload
    c.services.include?(s).should be_truthy
  end


  it "determines if it has access to a service" do
    c = consumer
    s = service
    s2 = FactoryGirl.create(:service)

    c.services << s
    c.save!

    c.can_access_service?(s).should be_truthy
    c.can_access_service?(s2).should be_falsey
  end


end
