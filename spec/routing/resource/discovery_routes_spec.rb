require 'spec_helper'

describe 'Discovery Routes', :type => :routing do
  it "routes to electronic search" do
    expect(get: "/1.0/resources/search/electronic").to route_to(
        controller: "resources/discovery",
        action: "index",
        search_type: "electronic"
      )
  end

  it "routes to catalog search" do
    expect(get: "/1.0/resources/search/catalog").to route_to(
        controller: "resources/discovery",
        action: "index",
        search_type: "catalog"
      )
  end
end
