class Admin::ConsumersController < Admin::BaseController
  # GET /consumers
  # GET /consumers.json
  def index
    @consumers = api_admin.list_consumers

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consumers }
    end
  end

  # GET /consumers/new
  # GET /consumers/new.json
  def new
    @consumer = api_admin.get_consumer

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @consumer }
    end
  end

  # GET /consumers/1/edit
  def edit
    @consumer = api_admin.get_consumer(params[:id])
  end

  # POST /consumers
  # POST /consumers.json
  def create
    @consumer = api_admin.add_consumer(consumer_params)

    respond_to do |format|
      if @consumer.valid?
        format.html { redirect_to admin_consumers_path, notice: 'Consumer was successfully created.' }
        format.json { render json: @consumer, status: :created, location: @consumer }
      else
        format.html { render action: "new" }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /consumers/1
  # PUT /consumers/1.json
  def update
    @consumer = api_admin.update_consumer(params[:id], consumer_params)

    respond_to do |format|
      if @consumer.valid?
        format.html { redirect_to admin_consumers_path, notice: 'Consumer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumers/1
  # DELETE /consumers/1.json
  def destroy
    api_admin.destroy_consumer(params[:id])

    respond_to do |format|
      format.html { redirect_to admin_consumers_url }
      format.json { head :no_content }
    end
  end

  private

  def consumer_params
    params.require(:admin_consumer).permit(:name, :description, :authentication_token, set_services: [])
  end
end
