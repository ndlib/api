require "spec_helper"

describe Admin::ConsumersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get("/admin/consumers")).to route_to("admin/consumers#index")
    end

    it "routes to #new" do
      expect(get("/admin/consumers/new")).to route_to("admin/consumers#new")
    end

    it "routes to #show" do
      expect(get("/admin/consumers/1")).to route_to("admin/consumers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(get("/admin/consumers/1/edit")).to route_to("admin/consumers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(post("/admin/consumers")).to route_to("admin/consumers#create")
    end

    it "routes to #update" do
      expect(put("/admin/consumers/1")).to route_to("admin/consumers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(delete("/admin/consumers/1")).to route_to("admin/consumers#destroy", :id => "1")
    end

  end
end
