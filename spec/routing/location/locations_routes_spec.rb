require 'spec_helper'

describe 'Locations Routes', :type => :routing do
  it "should route the maps" do
    expect(get: "/1.0/locations/maps").to route_to(
        controller: "locations/maps",
        action: "index"
      )
  end

  it "should route the hours" do
    expect(get: "/1.0/locations/hours").to route_to(
        controller: "locations/hours",
        action: "index"
      )
  end
end
