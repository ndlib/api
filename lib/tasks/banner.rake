namespace :banner do
  desc "reindex all course data"
  task reindex: :environment do
    clear_index()
    puts "scanning directories"

    Dir.glob("#{Rails.configuration.banner_dir.to_s}/**/*/").sort.reverse.each do |dir|
      path = dir.to_s
      process_files(Dir.new(path), false) unless path =~ /\.|\.\./ || Dir.glob("#{path}/*.tsv").length() == 0
    end
  end

  def process_files(dir, clear_flag)
    puts "banner_data from dir " + dir.path.to_s
    banner_data = CSVHelper.banner_data(dir)
    src = Sunspot::Rails::Configuration.new
    host = src.hostname
    port = src.port
    core = "api"
    Sunspot.config.solr.url = "http://#{host}:#{port}/solr/#{core}"
    puts "index_enrollments"
    Person::Student::Enrollment.index_enrollments(banner_data.students, clear_flag)
    puts "index_instructed_courses"
    Person::Instructor::Course.index_instructed_courses(banner_data.instructors, clear_flag)
    puts "index_courses"
    Resource::Course::Course.index_courses(banner_data.courses, clear_flag)
    puts "index_section_groups"
    Resource::Course::SectionGroup.index_section_groups(banner_data.section_groups, clear_flag)
    puts "index_sections"
    Resource::Course::Section.index_sections(banner_data.sections, clear_flag)
    puts "optimize"
    Sunspot.config.solr.read_timeout = 800
    Sunspot.optimize
  end

  def clear_index
    puts "clear index"
    src = Sunspot::Rails::Configuration.new
    host = src.hostname
    port = src.port
    core = "api"
    url = "http://#{host}:#{port}/solr/#{core}"
    log_file = File.join(Rails.root, "log", "solr-core.log").to_s
    sh "curl #{url}/update --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8' > #{log_file} 2>&1"
    sh "curl #{url}/update --data '<commit/>' -H 'Content-type:text/xml; charset=utf-8' > #{log_file} 2>&1"
  end
end
