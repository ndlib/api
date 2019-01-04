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

describe Admin::ConsumersController do
  before(:each) do
    login_user
  end

  # This should return the minimal set of attributes required to create a valid
  # Consumer. As you add validations to Consumer, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { :name => 'name'  }
  end


  describe "GET index" do

    it "assigns all consumers as @consumers" do
      consumer = FactoryGirl.create(:consumer)
      get :index, {}
      assigns(:consumers).should eq([consumer])
    end
  end

  describe "GET new" do
    it "assigns a new consumer as @consumer" do
      get :new, {}
      assigns(:consumer).should be_a_new(Admin::Consumer)
    end
  end

  describe "GET edit" do
    it "assigns the requested consumer as @consumer" do
      consumer = Admin::Consumer.create! valid_attributes
      get :edit, {:id => consumer.to_param}
      assigns(:consumer).should eq(consumer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::Consumer" do
        expect {
          post :create, {:admin_consumer => valid_attributes}
        }.to change(Admin::Consumer, :count).by(1)
      end

      it "assigns a newly created consumer as @consumer" do
        post :create, {:admin_consumer => valid_attributes}
        assigns(:consumer).should be_a(Admin::Consumer)
        assigns(:consumer).should be_persisted
      end

      it "redirects to the created consumer" do
        post :create, {:admin_consumer => valid_attributes}
        response.should redirect_to(admin_consumers_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved consumer as @consumer" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Consumer.any_instance.stub(:save).and_return(false)
        post :create, {:admin_consumer => { bogus: "Admin"  }}
        assigns(:consumer).should be_a_new(Admin::Consumer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Consumer.any_instance.stub(:save).and_return(false)
        post :create, {:admin_consumer => { bogus: "Admin" }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested consumer" do
        consumer = Admin::Consumer.create! valid_attributes
        # Assuming there are no other consumers in the database, this
        # specifies that the Admin::Consumer created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the requests.
        Admin::Consumer.any_instance.should_receive(:update_attributes).with({ name: "Admin" })
        put :update, {:id => consumer.to_param, :admin_consumer => { name: "Admin" }}
      end

      it "assigns the requested consumer as @consumer" do
        consumer = Admin::Consumer.create! valid_attributes
        put :update, {:id => consumer.to_param, :admin_consumer => valid_attributes}
        assigns(:consumer).should eq(consumer)
      end

      it "redirects to the consumer" do
        consumer = Admin::Consumer.create! valid_attributes
        put :update, {:id => consumer.to_param, :admin_consumer => valid_attributes}
        response.should redirect_to(admin_consumers_path)
      end
    end

    describe "with invalid params" do
      it "assigns the consumer as @consumer" do
        consumer = Admin::Consumer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Consumer.any_instance.stub(:save).and_return(false)
        put :update, {:id => consumer.to_param, :admin_consumer => { bogus: "Admin" }}
        assigns(:consumer).should eq(consumer)
      end

      it "re-renders the 'edit' template" do
        consumer = Admin::Consumer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Consumer.any_instance.stub(:valid?).and_return(false)
        put :update, {:id => consumer.to_param, :admin_consumer => { bogus: "Admin" }}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested consumer" do
      consumer = Admin::Consumer.create! valid_attributes
      expect {
        delete :destroy, {:id => consumer.to_param}
      }.to change(Admin::Consumer, :count).by(-1)
    end

    it "redirects to the consumers list" do
      consumer = Admin::Consumer.create! valid_attributes
      delete :destroy, {:id => consumer.to_param}
      response.should redirect_to(admin_consumers_url)
    end
  end

end
