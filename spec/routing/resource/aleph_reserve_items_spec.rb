require 'spec_helper'

describe 'Reserve Item Routes', :type => :routing do

  it "routes to all print reserves list" do
    expect(get: "/1.0/resources/courses/print_reserves/all").to route_to(
        controller: "resources/aleph_reserve_items",
        action: "all_aleph_reserves"
      )
  end


  it "routes to item rta status" do
    expect(get: "/1.0/resources/courses/print_reserves/rta/000048183").to route_to(
        controller: "resources/aleph_reserve_items",
        action: "rta_status",
        rta_number: '000048183'
      )
  end

end
