require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Admin::ServicesController do
  before(:each) do
    session[:netid] = OmniAuth.config.mock_auth[:okta].netid
    session[:authorized_admin] = true
    login_user
  end

  # This should return the minimal set of attributes required to create a valid
  # Admin::Service. As you add validations to Admin::Service, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { :name => 'Name', :path => '/Path', :service_class => 'Constant', :code => 'code'}
  end

  describe "GET index" do
    it "assigns all services as @services" do
      service = Admin::Service.create! valid_attributes
      get :index, {}
      expect(assigns(:services)).to eq ([service])
    end
  end

  describe "GET new" do
    it "assigns a new service as @service" do
      get :new, {}
      expect(assigns(:service)).to be_a_new(Admin::Service)
    end
  end

  describe "GET edit" do
    it "assigns the requested service as @service" do
      service = Admin::Service.create! valid_attributes
      get :edit, {:id => service.to_param}
      expect(assigns(:service)).to eq (service)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::Service" do
        expect {
          post :create, {:admin_service => valid_attributes}
        }.to change(Admin::Service, :count).by(1)
      end

      it "assigns a newly created service as @service" do
        post :create, {:admin_service => valid_attributes}
        expect(assigns(:service)).to be_a(Admin::Service)
        expect(assigns(:service)).to be_persisted
      end

      it "redirects to the created service" do
        post :create, {:admin_service => valid_attributes}
        expect(response).to redirect_to(admin_services_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved service as @service" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Service.any_instance.stub(:save).and_return(false)
        post :create, {:admin_service => { bogus: "Service" }}
        expect(assigns(:service)).to be_a_new(Admin::Service)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Service.any_instance.stub(:valid?).and_return(false)
        post :create, {:admin_service => { bogus: "Service" }}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested service" do
        service = Admin::Service.create! valid_attributes
        # Assuming there are no other services in the database, this
        # specifies that the Admin::Service created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the requests.
        Admin::Service.any_instance.should_receive(:update_attributes).with({ name: "Service" })
        put :update, {:id => service.to_param, :admin_service => { name: "Service" }}
      end

      it "assigns the requested service as @service" do
        service = Admin::Service.create! valid_attributes
        put :update, {:id => service.to_param, :admin_service => valid_attributes}
        expect(assigns(:service)).to eq(service)
      end

      it "redirects to the service" do
        service = Admin::Service.create! valid_attributes
        put :update, {:id => service.to_param, :admin_service => valid_attributes}
        expect(response).to redirect_to(admin_services_path)
      end
    end

    describe "with invalid params" do
      it "assigns the service as @service" do
        service = Admin::Service.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Service.any_instance.stub(:save).and_return(false)
        put :update, {:id => service.to_param, :admin_service => { bogus: "Service" }}
        expect(assigns(:service)).to eq(service)
      end

      it "re-renders the 'edit' template" do
        service = Admin::Service.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Service.any_instance.stub(:valid?).and_return(false)
        put :update, {:id => service.to_param, :admin_service => { bogus: "Service" }}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested service" do
      service = Admin::Service.create! valid_attributes
      expect {
        delete :destroy, {:id => service.to_param}
      }.to change(Admin::Service, :count).by(-1)
    end

    it "redirects to the services list" do
      service = Admin::Service.create! valid_attributes
      delete :destroy, {:id => service.to_param}
      expect(response).to redirect_to(admin_services_url)
    end
  end

end
