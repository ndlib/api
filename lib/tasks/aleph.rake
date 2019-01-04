namespace :aleph do
  desc "Reindex Aleph course reserve data"
  task :reindex => :environment do
    puts 'aleph_reserves'
    aleph_reserves = CSVHelper.aleph_data
    puts 'remove reserve items'
    Sunspot.remove_all(Resource::Aleph::ReserveItem)
    puts 'commit'
    Sunspot.commit
    puts 'index_aleph_reserves'
    Resource::Aleph::ReserveItem.index_aleph_reserves(aleph_reserves.print_reserves)
    puts 'optimize'
    Sunspot.optimize
  end
end
