require 'spec_helper'

describe Admin::Service do

  let(:consumer) { FactoryGirl.create(:consumer) }
  let(:service)  { FactoryGirl.create(:service) }

  it "has associtions to the service model" do
    service.methods.include?(:consumers).should be_truthy
  end

  it "can have services added to it" do
    c = consumer
    s = service

    s.consumers << c
    s.save!

    s.reload
    s.consumers.include?(c).should be_truthy
  end

end
