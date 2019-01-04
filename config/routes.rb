Api::Application.routes.draw do

  devise_for :consumers, :class_name => 'Admin::Consumer'
  devise_for :users, :class_name => 'Admin::User'

  root to: 'admin/services#index'

  namespace 'admin' do
    root to: 'services#index'

    resources :consumers
    resources :users
    resources :services


    match 'expire_all_cache' => 'cache_expiration#expire_all_cache', via: [:get, :post]
    match ':service_id/expire_service_cache' => 'cache_expiration#expire_service_cache', :as => 'expire_service_cache', via: [:get, :post]
  end

  scope '/1.0' do
    scope '/locations' do
      match 'maps' => 'locations/maps#index', :as => :maps, via: [:get]
      match 'hours' => 'locations/hours#index', :as => :hours, via: [:get]
    end

    scope '/resources' do
      match 'sublibraries' => 'resources/datamart#sublibraries', :as => :sublibraries, via: [:get]
      match 'sublibrary_collections' => 'resources/datamart#sublibrary_collections', :as => :sublibrary_collections, via: [:get]


      scope '/athletics' do
        match 'schedule' => 'resources/athletics#schedule', as: :athletics_schedule_current_year, via: [:get]
        match 'schedule/:year' => 'resources/athletics#schedule', as: :athletics_schedule, via: [:get]
      end

      scope '/courses' do
        get 'course', :as => 'single_course_using_triple', :controller => 'resources/course', :path => '/by_course_triple/:course_triple'
        get 'course', :as => 'single_course_using_term_alpha_number', :controller => 'resources/course', :path => '/by_course_id/:term/:alpha/:number'
        get 'course', :as => 'single_course_using_term_crn', :controller => 'resources/course', :path => '/by_section/:term/:crn'
        get 'course', :as => 'single_course_using_section_group_id', :controller => 'resources/course', :path => '/by_section_group/:section_group_id'
        get 'course', :as => 'single_course_using_supersection_id', :controller => 'resources/course', :path => '/by_supersection/:supersection_id'
        get 'course', :as => 'single_course_using_crosslist_id', :controller => 'resources/course', :path => '/by_crosslist/:crosslist_id'
        get 'course_search', :as => 'course_search', :controller => 'resources/course', :path => '/search'
        scope '/print_reserves' do
          get 'all_aleph_reserves', :controller => 'resources/aleph_reserve_items', :path => '/all'
          get 'rta_status', :controller => 'resources/aleph_reserve_items', :path => '/rta/:rta_number'
        end
      end

      scope '/holds' do
        get 'holds_list', :as => 'holds_list', :controller => 'discovery2/holds', :path => '/list/:patron_id/:discovery_id'
        put 'place_request', :as => 'place_request_1', :controller => 'discovery2/holds', :path => '/request'
      end

      scope '/items' do
        get 'aleph_item', :as => 'item', :controller => 'resources/aleph', :path => '/record'
        get 'active_requests', :as => 'annex_requests', :controller => 'resources/aleph', :path => '/active_requests'
        post 'stock_aleph_item', :as => 'stock_item', :controller => 'resources/aleph', :path => '/stock'
        post 'send_fulfillment', :as => 'send_item', :controller => 'resources/aleph', :path => '/send'
        post 'scan_fulfillment', :as => 'scan_item', :controller => 'resources/aleph', :path => '/scan'
        post 'deaccession_item', :as => 'deaccession_item', :controller => 'resources/aleph', :path => '/deaccession'
        post 'archive_request', :as => 'archive_request', :controller => 'resources/aleph', :path => '/archive_request'
      end

      scope '/search' do
        match 'electronic' => 'resources/discovery#index', as: :search_electronic, search_type: 'electronic', via: [:get, :post]
        match 'catalog' => 'resources/discovery#index', as: :search_catalog, search_type: 'catalog', via: [:get, :post]
        match 'blended' => 'resources/discovery#index', as: :search_blended, search_type: 'blended', via: [:get, :post]
        match 'id' => 'resources/discovery#index', as: :search_id, search_type: 'id', via: [:get, :post]
      end
    end

    scope '/discovery' do
      match 'electronic' => 'resources/discovery#index', as: :discovery_electronic, search_type: 'electronic', via: [:get, :post]
      match 'catalog' => 'resources/discovery#index', as: :discovery_catalog, search_type: 'catalog', via: [:get, :post]
      match 'blended' => 'resources/discovery#index', as: :discovery_blended, search_type: 'blended', via: [:get, :post]
      match 'id' => 'resources/discovery#index', as: :discovery_id, search_type: 'id', via: [:get, :post]
      match 'record_id' => 'resources/discovery#index', as: :discovery_record_id, search_type: 'record_id', via: [:get, :post]
    end


    scope '/people' do
      get 'all_by_population_context', :as => 'people_all_by_population', :path => '/:population_context/all', :controller => 'person'
      get 'search', :as => 'people_search', :path => '/search/:value', :controller => 'person'
      get 'person', :as => 'people_single_person', :path => '/:identifier/:id', :controller => 'person'
      get 'courses', :as => 'people_courses_single_person', :path => '/:identifier/:id/:term/courses', :controller => 'person'
    end

    scope '/orgs' do
      get 'all_by_population_context', :as => 'orgs_all_by_population', :path => '/:population_context/all', :controller => 'org'
      get 'org', :as => 'orgs_single_org', :path => '/:population_context/:id', :controller => 'org'
    end

  end

  scope '/2.0' do
    scope '/discovery' do
      match 'id' => 'discovery2/records#show', via: [:get, :post]
      match 'detail' => 'discovery2/records#detail', via: [:get, :post]
      match 'fullview' => 'discovery2/records#fullview', via: [:get, :post]
      match 'sfx' => 'discovery2/records#sfx', via: [:get, :post]
      match 'holdings' => 'discovery2/records#holdings', via: [:get, :post]

      scope '/holds' do
        get 'holds_list', :as => 'holds_list_using_patron_id_discovery_id', :controller => 'discovery2/holds', :path => '/list/:patron_id/:discovery_id'
        get 'holds_list', :as => 'holds_list_using_patron_id', :controller => 'discovery2/holds', :path => '/list/:patron_id'
        put 'place_request', :as => 'place_request_2', :controller => 'discovery2/holds', :path => '/request'
      end
    end
  end

end
