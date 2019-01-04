require 'spec_helper'

describe 'Sublibrary Collection Routes', :type => :routing do
  it "should route the sublibrary_collections" do
    expect(get: "/1.0/resources/sublibrary_collections").to route_to(
        controller: "resources/datamart",
        action: "sublibrary_collections"
      )
  end
end
