# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


["mkirkpa2","rdoughty","jgondron","jhartzle","rfox2","awetheri","dwolfe2"].each do | username |
  unless Admin::User.where(:username => username).first
     Admin::User.new(:username => username).save!
  end
end

api_admin = Admin::ApiAdmin.new

unless Admin::Consumer.where(:name => 'Hours').first
  consumer = api_admin.add_consumer({ name: 'Hours', authentication_token: 'hours'})
  service = api_admin.add_service({name: 'Hours API', code: 'hours', service_class: 'Location::Hours', path: '/1.0/locations/hours' })
  consumer.services << service
  consumer.save!
end

unless Admin::Consumer.where(:name => 'Person').first
  consumer = api_admin.add_consumer({ name: 'Person', authentication_token: 'srDhuT6CjWS2as8eyMtR'})
  service = api_admin.add_service({name: 'Person API', code: 'person', service_class: 'Person::Base', path: '/1.0/people%' })
  consumer.services << service
  consumer.save!
end

unless Admin::Consumer.where(:name => 'Org').first
  consumer = api_admin.add_consumer({ name: 'Org', authentication_token: 'EtnHZrKbRWd2vqJLhqYc'})
  service = api_admin.add_service({name: 'Org API', code: 'org', service_class: 'Organization', path: '/1.0/orgs%' })
  consumer.services << service
  consumer.save!
end

unless Admin::Consumer.where(:name => 'Maps').first
  consumer = api_admin.add_consumer({ name: "Maps", authentication_token: (Rails.env == 'production' ? nil : 'maps') })
  service = api_admin.add_service({name: 'Maps Api', code: 'maps', service_class: 'Maps', path: '/1.0/locations/maps%' })
  consumer.services << service
  consumer.save!
end

unless Admin::Consumer.where(:name => 'Sublibrary').first
  consumer = api_admin.add_consumer({ name: "Sublibrary", authentication_token: (Rails.env == 'production' ? nil : 'sublibrary') })
  service = api_admin.add_service({name: 'Sublibrary Api', code: 'sublibrary', service_class: 'Resource::Sublibrary', path: '/1.0/resources/sublibraries' })
  consumer.services << service
  service = api_admin.add_service({name: 'Sublibrary Collection Api', code: 'sublibrary_collection', service_class: 'Resources::SublibraryCollection', path: '/1.0/resources/sublibrary_collections' })
  consumer.services << service
  consumer.save!
end

unless Admin::Consumer.where(:name => 'Discover').first
  consumer = api_admin.add_consumer({ name: "Discover", authentication_token: (Rails.env == 'production' ? nil : 'discover') })
  service = api_admin.add_service({name: 'Discover 2.0', code: 'discover2', service_class: 'Discovery2::RecordDetailRequest', path: '/2.0/discovery/%' })
  consumer.services << service
  consumer.save!
end

unless Admin::Consumer.where(:name => 'Item').first
  consumer = api_admin.add_consumer({ name: "Item", authentication_token: (Rails.env == 'production' ? nil : 'item') })
  service = api_admin.add_service({name: 'Item API', code: 'items', service_class: 'Aleph::Item', path: '/1.0/resources/items/%' })
  consumer.services << service
  consumer.save!
end
