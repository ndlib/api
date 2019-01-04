require 'spec_helper'

describe 'Discovery Routes', :type => :routing do
  it "routes to electronic search" do
    expect(get: "/1.0/discovery/electronic").to route_to(
        controller: "resources/discovery",
        action: "index",
        search_type: "electronic"
      )
  end

  it "routes to catalog search" do
    expect(get: "/1.0/discovery/catalog").to route_to(
        controller: "resources/discovery",
        action: "index",
        search_type: "catalog"
      )
  end


  it "routes to id search" do
    expect(get: "/1.0/discovery/id").to route_to(
        controller: "resources/discovery",
        action: "index",
        search_type: "id"
      )
  end

end
