class Admin::UsersController < Admin::BaseController
  # GET /users
  # GET /users.json
  def index
    @users = api_admin.list_users

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end


  # GET /users/new
  # GET /users/new.json
  def new
    @user = api_admin.get_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = api_admin.get_user(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = api_admin.add_user(admin_params)

    respond_to do |format|
      if @user.valid?
        format.html { redirect_to admin_users_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = api_admin.update_user(params[:id], admin_params)

    respond_to do |format|
      if @user.valid?
        format.html { redirect_to admin_users_path, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = api_admin.destroy_user(params[:id])

    respond_to do |format|
      format.html { redirect_to admin_users_path }
      format.json { head :no_content }
    end
  end

  private

  def admin_params
    params.require(:admin_user).permit(:name, :username)
  end
end
