require 'spec_helper'

describe 'Sublibrary Routes', :type => :routing do
  it "should route the sublibraries" do
    expect( :get => "/1.0/resources/sublibraries" ).to route_to(
        :controller => "resources/datamart",
        :action => "sublibraries"
      )
  end
end
