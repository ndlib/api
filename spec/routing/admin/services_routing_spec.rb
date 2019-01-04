require "spec_helper"

describe Admin::ServicesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get("/admin/services")).to route_to("admin/services#index")
    end

    it "routes to #new" do
      expect(get("/admin/services/new")).to route_to("admin/services#new")
    end

    it "routes to #show" do
      expect(get("/admin/services/1")).to route_to("admin/services#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/admin/services/1/edit")).to route_to("admin/services#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/admin/services")).to route_to("admin/services#create")
    end

    it "routes to #update" do
      expect(put("/admin/services/1")).to route_to("admin/services#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/admin/services/1")).to route_to("admin/services#destroy", :id => "1")
    end

  end
end
