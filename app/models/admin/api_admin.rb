class Admin::ApiAdmin

  def determine_service_from_path(request_path)
    if File.extname(request_path).present?
      request_path.gsub!(File.extname(request_path), "")
    end

    service_class.determine_service_from_path(request_path).first
  end


  def get_service_by_code(code)
    service_class.where(code: code).first
  end


  def list_services(search_parans = {})
    service_class.order(:name)
  end


  def get_service(id = false)
    if id
      service_class.find(id)
    else
      service_class.new
    end
  end


  def add_service(params)
    service = service_class.new(params)

    if service.save
      Admin::ApiPermission.expire_cache
    end

    service
  end


  def update_service(service_id, params)
    service = get_service(service_id)
    if service.update_attributes(params)
      Admin::ApiPermission.expire_cache
    end

    service
  end


  def destroy_service(service_id)
    service = get_service(service_id)

    if service.destroy
      Admin::ApiPermission.expire_cache
    end

    service
  end


  def list_consumers
    consumer_class.order(:name)
  end


  def get_consumer(id = false)
    if id
      consumer_class.find(id)
    else
      consumer_class.new
    end
  end

  def add_consumer(params)
    consumer = consumer_class.new(params)

    if consumer.save
      Admin::ApiPermission.expire_cache
    end

    consumer
  end


  def update_consumer(consumer_id, params)
    consumer = get_consumer(consumer_id)
    if consumer.update_attributes(params)
      Admin::ApiPermission.expire_cache
    end

    consumer
  end


  def destroy_consumer(consumer_id)
    consumer = get_consumer(consumer_id)
    if consumer.destroy
      Admin::ApiPermission.expire_cache
    end

    consumer
  end

   def list_users
    user_class.order(:name)
  end


  def get_user(id = false)
    if id
      user_class.find(id)
    else
      user_class.new
    end
  end

  def add_user(params)
    user = user_class.new(params)
    user.save

    user
  end


  def update_user(user_id, params)
    user = get_user(user_id)
    user.update_attributes(params)

    user
  end


  def destroy_user(user_id)
    user = get_user(user_id)
    user.destroy

    user
  end

  protected


  def service_class
    Admin::Service
  end


  def consumer_class
    Admin::Consumer
  end

  def user_class
    Admin::User
  end


end
