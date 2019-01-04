class Admin::ServicesController < Admin::BaseController

    # GET /services
    # GET /services.json
    def index
      @services = api_admin.list_services

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @services }
      end
    end

    # GET /services/new
    # GET /services/new.json
    def new
      @service = api_admin.get_service

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @service }
      end
    end

    # GET /services/1/edit
    def edit
      @service = api_admin.get_service(params[:id])
    end

    # POST /services
    # POST /services.json
    def create
      @service = api_admin.add_service(admin_service_params)

      respond_to do |format|
        if @service.valid?
          format.html { redirect_to admin_services_path, notice: 'Service was successfully created.' }
          format.json { render json: @service, status: :created, location: @service }
        else
          format.html { render action: "new" }
          format.json { render json: @service.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /services/1
    # PUT /services/1.json
    def update
      @service = api_admin.update_service(params[:id], admin_service_params) 

      respond_to do |format|
        if @service.valid?
          format.html { redirect_to admin_services_path, notice: 'Service was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @service.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /services/1
    # DELETE /services/1.json
    def destroy
      api_admin.destroy_service(params[:id])

      respond_to do |format|
        format.html { redirect_to admin_services_url }
        format.json { head :no_content }
      end
    end

    private

    def admin_service_params
      params.require(:admin_service).permit(:name, :description, :parameters, :path, :service_class, :code)
    end

end
