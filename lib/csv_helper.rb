module CSVHelper
  def self.banner_data(dir)
    BannerData.new(dir)
  end

  def self.aleph_data
    AlephData.new
  end

  class BannerData
    require "csv"

    attr_reader :instructors, :students, :courses, :sections, :section_groups

    def initialize(dir)
      @banner_directory = dir
      enrollment_parse
    end

    def enrollment_parse
      @crosslist_data = crosslists
      @supersection_data = supersections
      @course_title_data = course_titles
      open_banner_file("enrollment").each do |fields|
        data_elements = {}
        enrollment_line_elements.each_with_index do |element, index|
          data_elements[element] = fields[index]
        end
        extract_instructors_students_sections(data_elements)
      end
      extract_crosslists
      extract_courses
      match_instructor_section_groups
    end

    def course_titles
      titles = {}
      open_banner_file("coursesectiontitles").each do |fields|
        c_term, c_alpha_prefix, c_number, c_brief_title, c_full_title = fields[0..5]
        unique_title_id = "#{c_alpha_prefix}_#{c_number}"
        titles[unique_title_id.to_s] = if c_full_title.blank?
                                         c_brief_title
                                       else
                                         c_full_title
                                       end
      end
      titles
    end

    def crosslists
      crosslists = {}
      open_banner_file("crosslists").each do |fields|
        cl_term, cl_crosslist_number, cl_crn = fields[0..2]
        crosslist_id = "#{cl_term}_#{cl_crosslist_number}"
        unique_section_id = "#{cl_term}_#{cl_crn}"
        crosslists[unique_section_id] = crosslist_id
      end
      crosslists
    end

    def supersections
      supersections = {}
      open_banner_file("supersections").each do |fields|
        ss_term, ss_name, ss_crn = fields[0..2]
        supersection_id = ss_name.to_s
        unique_section_id = "#{ss_term}_#{ss_crn}"
        supersections[unique_section_id] = supersection_id
      end
      supersections
    end

    def open_banner_file(type)
      CSV.instance(banner_file_object(type), banner_file_type_options(type))
    end

    def banner_file_object(type)
      File.open(banner_filepath(type))
    end

    def banner_filepath(type)
      @banner_directory.to_path + "/#{type}.tsv"
    end

    def banner_file_type_options(type)
      if type == "enrollment"
        {col_sep: "\t", row_sep: "\n"}
      else
        {quote_char: "}", col_sep: "\t", row_sep: "\n"}
      end
    end

    def enrollment_line_elements
      [:term, :alpha_prefix, :number, :section, :netid, :fname, :lname, :role, :status, :crn]
    end

    def extract_instructors_students_sections(data_elements)
      if data_elements[:role] == "Instructor"
        instructor_record = extract_instructor_data(data_elements)
        @instructors[instructor_record[:unique_id]] = instructor_record
      end
      if data_elements[:role] == "Student"
        student_record = extract_student_data(data_elements)
        @students[student_record[:unique_id]] = student_record
      end
      section_record = extract_section_data(data_elements)
      @sections[section_record[:unique_id]] = section_record
    end

    def extract_instructor_data(data_elements)
      instructor = find_instructor(unique_person_id(data_elements))
      instructor[:netid] = data_elements[:netid]
      instructor[:term] = data_elements[:term]
      instructor[:status] = data_elements[:status]
      instructor[:section_groups] = {} if instructor[:section_groups].blank?


      if data_elements[:status] == "Primary"
        instructor[:section_groups][course_triple(data_elements).to_s] = build_instructor_section_groups(instructor, data_elements)
      end
      instructor
    end

    def unique_person_id(data_elements)
      "#{data_elements[:term]}_#{data_elements[:netid]}"
    end

    def find_instructor(unique_id)
      @instructors = {} if @instructors.blank?
      if @instructors[unique_id]
        instructor = @instructors[unique_id]
      else
        instructor = {}
        instructor[:unique_id] = unique_id
      end
      instructor
    end

    def build_instructor_section_groups(instructor, data_elements)
      if data_elements[:status] == "Primary"
        if instructor[:section_groups].include? course_triple(data_elements).to_s
          section_groups = instructor[:section_groups][course_triple(data_elements).to_s]
          unique_section_id = section_groups[:unique_section_group_id] + "_" + data_elements[:crn]
        else
          section_groups = {}
          unique_section_id = data_elements[:term] + "_" + data_elements[:crn]
        end
        section_groups[:unique_section_group_id] = unique_section_id
        section_groups[:course_title] = get_title(data_elements)
        section_groups[:sections] = [] if section_groups[:sections].blank?
        section_groups[:sections].push(section_id(data_elements))
      end
      section_groups
    end

    def course_triple(data_elements)
      triple = "#{data_elements[:term]}_#{data_elements[:alpha_prefix]}_#{data_elements[:number]}"
      if triple === "202010_ENGL_13186"        
        triple += "_#{data_elements[:section]}"
      end

      triple
    end

    def get_title(data_elements)
      course_alpha_num = data_elements[:alpha_prefix] + "_" + data_elements[:number]
      titles = @course_title_data
      if titles.has_key?(course_alpha_num)
        titles[course_alpha_num]
      else
        data_elements[:alpha_prefix] + " " + data_elements[:number]
      end
    end

    def section_id(data_elements)
      "#{data_elements[:term]}_#{data_elements[:crn]}"
    end

    def extract_student_data(data_elements)
      student = find_student(unique_person_id(data_elements))
      student[:netid] = data_elements[:netid]
      student[:term] = data_elements[:term]
      student[:enrollments] = define_enrollment(student, data_elements)
      student
    end

    def find_student(unique_id)
      @students = {} if @students.blank?
      if @students[unique_id]
        student = @students[unique_id]
      else
        student = {}
        student[:unique_id] = unique_id
      end
      student
    end

    def define_enrollment(enrollment_obj, data_elements)
      unique_id = nil

      if enrollment_obj[:netid] == data_elements[:netid]
        unique_id = section_id(data_elements)
      else
        unique_id = person_unique_id(data_elements)
      end

      if data_elements[:status] == "Dropped"
        unless enrollment_obj[:enrollments].blank?
          enrollment_obj[:enrollments].delete_if { |enrollment| enrollment == unique_id }
        end
      elsif data_elements[:status] == "Enrolled"
        enrollment_obj[:enrollments] = [] if enrollment_obj[:enrollments].blank?
        enrollment_obj[:enrollments].push(unique_id)
      end

      enrollment_obj[:enrollments]
    end

    def person_unique_id(data_elements)
      "#{data_elements[:term]}_#{data_elements[:netid]}"
    end

    def extract_section_data(data_elements)
      section = find_section(data_elements)
      section[:unique_id] = section_id(data_elements)
      if data_elements[:role] == "Student"
        section[:enrollments] = define_enrollment(section, data_elements)
      end
      if data_elements[:role] == "Instructor"
        section[:instructors] = [] if section[:instructors].blank?
        section[:instructors].push(person_unique_id(data_elements))
        if data_elements[:status] == "Primary"
          section[:primary_instructor] = data_elements[:netid]
        end
      end
      section[:term] = data_elements[:term]
      section[:course_title] = get_title(data_elements)
      section[:alpha_prefix] = data_elements[:alpha_prefix]
      section[:number] = data_elements[:number]
      section[:section_number] = data_elements[:section]
      section[:crn] = data_elements[:crn]
      section[:term_crn] = section_id(data_elements)
      section[:supersection_id] = @supersection_data[section_id(data_elements)]
      section
    end

    def find_section(data_elements)
      @sections = {} if @sections.blank?

      if @sections[section_id(data_elements)]
        section = @sections[section_id(data_elements)]
      else
        section = {}
        section[:unique_id] = section_id(data_elements)
      end
      section
    end

    def extract_crosslists
      @instructors.keys.each do |instructor_id|
        crosslist_per_section_group(instructor_id)
      end
    end

    def crosslist_per_section_group(instructor_id)
      section_groups = @instructors[instructor_id.to_s][:section_groups]
      term = @instructors[instructor_id.to_s][:term]
      section_groups.keys.each do |section_group_key|
        crosslist_string = build_crosslist_string(section_group_key, section_groups)
        section_groups[section_group_key][:crosslist_id] = term + crosslist_string
      end
      @instructors[instructor_id][:section_groups] = section_groups
    end

    def build_crosslist_string(section_group_key, section_groups)
      @fix_ids ||= {}
      unique_crosslist_identifier = {}
      crosslist_string = ""
      crosslist_arr = []
      section_groups[section_group_key][:sections].each do |section|
        section =~ /.+?_(.+)/
        if @crosslist_data[section].blank?
          crosslist_string += "_" + $1
          crosslist_arr.push($1)
        else
          @crosslist_data[section] =~ /.+?_(.+)/
          unless unique_crosslist_identifier.has_key? $1
            unique_crosslist_identifier["#{$1}"] = 1
            crosslist_string += "_" + $1
            crosslist_arr.push($1)
          end
        end
      end
      if ("_" + crosslist_arr.sort.join("_") != crosslist_string)
        @fix_ids["201720" + crosslist_string] = "201720_" + crosslist_arr.sort.join("_")
      end
      if crosslist_string == "_CB_FP_DZ"
        crosslist_string = "_CB_DZ_FP"
      end

      # use this in the summer
      # "_" + crosslist_arr.sort.join("_")
      crosslist_string
    end

    def change_ids
      @fix_ids
    end

    def extract_courses
      @courses = {}
      @instructors.keys.each do |instructor_id|
        instructor = @instructors[instructor_id.to_s]
        section_groups = instructor[:section_groups]
        section_groups.keys.each do |section_group_key|
          section_group = section_groups[section_group_key]
          course = find_course(section_group_key)
          course[:title] =  section_group[:course_title]
          course[:term] = instructor[:term]
          course[:section_groups] = build_course_section_group_list(course, section_group)
          course[:instructors] = build_instructor_list(course, instructor)
          course[:supersections] = build_supersection_list(course)
          @courses[section_group_key] = course
          build_section_group(section_group, section_group_key)
        end
      end
    end

    def find_course(section_group_key)
      if @courses[section_group_key].blank?
        course = {}
        course[:unique_id] = section_group_key
      else
        course = @courses[section_group_key]
      end
      course
    end

    def build_course_section_group_list(course, section_group)
      course[:section_groups] = [] if course[:section_groups].blank?
      unless course[:section_groups].include? section_group[:unique_section_group_id]
        course[:section_groups].push(section_group[:unique_section_group_id])
      end
      course[:section_groups]
    end

    def build_instructor_list(course, instructor)
      course[:instructors] = [] if course[:instructors].blank?
      unless course[:instructors].include? instructor[:unique_id]
        course[:instructors].push(instructor[:unique_id])
      end
      course[:instructors]
    end

    def build_supersection_list(course)
      course[:supersections] = [] if course[:supersections].blank?
      course[:section_groups].each do |section_group|
        section_group =~ /(\d+)_(.+)/
        section_group_term = $1
        crn_list = $2.split("_")
        crn_list.each do |crn|
          if @supersection_data["#{section_group_term}_#{crn}"]
            unless course[:supersections].include? @supersection_data["#{section_group_term}_#{crn}"]
              course[:supersections].push(@supersection_data["#{section_group_term}_#{crn}"])
            end
          end
        end
      end
      course[:supersections]
    end

    def build_section_group(section_group, section_group_key)
      @section_groups = {} if @section_groups.blank?
      unique_section_group_id = section_group[:unique_section_group_id]
      unique_section_group = find_section_group(unique_section_group_id)
      unless unique_section_group[:primary_instructor]
        unique_section_group[:sections] = section_group[:sections]
        unique_section_group[:crosslist_id] = section_group[:crosslist_id]
        unique_section_group[:primary_instructor] = @sections[section_group[:sections].first][:primary_instructor]
        unique_section_group[:course_triple] = section_group_key
        unique_section_group[:unique_section_group_id] = unique_section_group_id
      end
      @section_groups[unique_section_group_id] = unique_section_group
    end

    def find_section_group(unique_section_group_id)
      if @section_groups.include?(unique_section_group_id)
        @section_groups[unique_section_group_id]
      else
        {}
      end
    end

    def match_instructor_section_groups
      @section_groups.keys.each do |section_group_id|
        section_group = @section_groups[section_group_id]
        section_group[:sections].each do |section_id|
          @sections[section_id][:instructors].each do |instructor_unique_id|
            @instructors[instructor_unique_id][:section_groups][section_group_id] = section_group
          end
        end
      end
      @instructors.keys.each do |instructor_id|
        @instructors[instructor_id][:section_groups].keys.each do |section_group_id|
          if section_group_id =~ /_[a-zA-Z]+_/
            @instructors[instructor_id][:section_groups].delete(section_group_id)
          end
        end
      end
    end
  end

  class AlephData
    require "csv"
    require "nokogiri"
    require "net/http"
    require "uri"

    attr_reader :print_reserves

    def initialize
      aleph_parse
    end

    def aleph_parse
      @print_reserves = Hash.new
      @unique_sid_list = Array.new
      open_aleph_file("print_reserves").each do |reserve_set|
        reserve_course_elements = reserve_set_elements(reserve_set)
        if (Date.parse("#{reserve_course_elements[:begin_date]}") <= Date.today + 2.months) && (Date.parse("#{reserve_course_elements[:end_date]}") >= Date.today)
          formatted_course_id = fix_formatting_errors(reserve_course_elements[:course_identifier])
          reserve_entry_items, course_triple = extract_course_reserves(reserve_course_elements)
          unless reserve_entry_items.empty?
            @print_reserves["#{formatted_course_id}"] = reserve_entry_items
          end
        end
      end
    end

    def open_aleph_file(type)
      CSV.instance(aleph_file_object(type), aleph_file_type_options(type))
    end

    def aleph_file_object(type)
      File.open(aleph_filepath(type))
    end

    def aleph_filepath(type)
      eval("Rails.configuration.#{type}_file")
    end

    def aleph_file_type_options(type)
      {:quote_char => "}", :col_sep => "\t", :row_sep => "\n"}
    end

    def extract_course_reserves(reserve_course_elements)
      formatted_course_id = fix_formatting_errors(reserve_course_elements[:course_identifier])
      aleph_course_xml = get_course_xml(formatted_course_id)
      no_entries = aleph_course_xml.xpath("//no_entries").first
      set_number = aleph_course_xml.xpath("//set_number").first
      reserve_entry_items = Array.new
      unless no_entries.nil?
        for item_number in 1 .. no_entries.content.to_i
          item_data_xml = get_item_xml(set_number.content, item_number.to_s)
          sid = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\"SID\"]/subfield[@label=\"a\"]").first.content
          if @unique_sid_list.include?(sid)
            next
          else
            @unique_sid_list.push(sid)
          end
          bib_id = /NDU\d+-(?<bib_id>\d+)-/.match(sid)[:bib_id]
          doc_id = item_data_xml.xpath("//present/record/doc_number").first.content
          title = get_title(item_data_xml)
          publisher = get_publisher(item_data_xml)
          creator = get_creator(item_data_xml)
          format = get_format(item_data_xml)
          if formatted_course_id =~ /^\w+-\d+/
            course_triple = get_course_triple(formatted_course_id, reserve_course_elements[:begin_date], reserve_course_elements[:end_date])
            section_number = get_section_number(formatted_course_id)
            (section_group, crosslist_id) = Resource::Aleph::ReserveItem.find_section_group(course_triple, section_number.to_i)
            if section_group
              aleph_reserve_item = Resource::Aleph::ReserveItem.new
              aleph_reserve_item.sid = sid
              aleph_reserve_item.bib_id = bib_id
              aleph_reserve_item.doc_number = doc_id
              aleph_reserve_item.title = title
              aleph_reserve_item.publisher = publisher
              aleph_reserve_item.creator = creator
              aleph_reserve_item.format = format
              aleph_reserve_item.course_triple = course_triple
              aleph_reserve_item.section_group_id = section_group
              aleph_reserve_item.crosslist_id = crosslist_id
              reserve_entry_items.push(aleph_reserve_item)
            end
          end
        end
      end
      return reserve_entry_items, course_triple
    end

    def reserve_set_elements(reserve_set)
      data_elements = Hash.new
      reserve_line_elements.each_with_index do |element, index|
        data_elements[element] = reserve_set[index]
      end
      data_elements
    end

    def reserve_line_elements
      [:course_identifier, :unknown, :course_title, :instructor_name, :department, :begin_date, :end_date, :term]
    end

    def fix_formatting_errors(course_record_id)
      course_record_id.gsub!(/\s/, "-")
      course_record_id.gsub!(/\s/, "")
      course_record_id
    end

    def get_course_xml(course_id)
      course_xservices_url = aleph_xservices_url(course_id)
      response = Net::HTTP.get_response(URIParser.call(course_xservices_url))
      Nokogiri::XML(response.body)
    end

    def get_item_xml(set_number, item_number)
      item_xservices_url = aleph_xservices_item_url(set_number, item_number)
      response = Net::HTTP.get_response(URIParser.call(item_xservices_url))
      Nokogiri::XML(response.body)
    end

    def aleph_xservices_url(course_id)
      Rails.configuration.aleph_course_reserves.sub(/\<\<course_id\>\>/, "#{Rack::Utils.escape(course_id)}")
    end

    def aleph_xservices_item_url(set_number, item_number)
      Rails.configuration.aleph_reserve_items.sub(/\<\<item_number\>\>/, "#{Rack::Utils.escape(item_number)}").sub(/\<\<set_id\>\>/, "#{Rack::Utils.escape(set_number)}")
    end

    def get_title(item_data_xml)
      title_a_node = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\"245\"]/subfield[@label=\"a\"]").first
      title = ""
      unless title_a_node.nil?
        title = title_a_node.content
      end
      title_b_node = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\"245\"]/subfield[@label=\"b\"]").first
      unless title_b_node.nil?
        title = title + title_b_node.content
      end
      title.gsub!(/\/$/, "")
      title.gsub!(/\.$/, "")
      title.strip!
      title
    end

    def get_publisher(item_data_xml)
      publisher_node = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\"260\"]").first
      publisher = nil
      unless publisher_node.nil?
        publisher = publisher_node.content
        publisher.gsub!(/\/$/, "")
        publisher.gsub!(/\[/, "")
        publisher.gsub!(/\]/, "")
        publisher.strip!
      end
      publisher
    end

    def get_creator(item_data_xml)
      creator_node = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\"100\"]").first
      creator = nil
      unless creator_node.nil?
        creator = creator_node.content
        creator.gsub!(/\/$/, "")
        creator.gsub!(/\.$/, "")
        creator.strip!
      end
      creator
    end

    def get_format(item_data_xml)
      format_node = item_data_xml.xpath("//present/record/metadata/oai_marc/varfield[@id=\"PST\"]/subfield[@label=\"3\"]").first
      format = ""
      unless format_node.nil?
        format = format_node.content
      end
      format
    end

    def get_course_triple(formatted_course_id, begin_date, end_date)
      formatted_course_id =~ /^(\w+)-(\d+)/
      course_alpha = $1
      course_number = $2
      if term_year && term_num_suffix(begin_date, end_date) && course_alpha && course_number
        course_triple = term_year.to_s + term_num_suffix(begin_date, end_date) + "_" + course_alpha + "_" + course_number
      end
      course_triple
    end

    def get_section_number(formatted_course_id)
      formatted_course_id =~ /^\w+-\d+-(\d+)$/
      section_number = $1
      unless section_number
        section_number = "01"
      end
      section_number
    end

    def term_year
      if Date.today.mon >= 1 && Date.today.mon <= 5
        Date.today.year - 1
      else
        Date.today.year
      end
    end

    def term_num_suffix(begin_date, end_date)
      s_year = Date.parse(begin_date).year
      e_year = Date.parse(end_date).year
      if Date.parse(begin_date) >= Date.parse("December 15th, " + december_start_year.to_s) && Date.parse(end_date) <= Date.parse("June 1st, #{e_year}")
        "20"
      elsif Date.parse(begin_date) >= Date.parse("May 1st, #{s_year}") && Date.parse(end_date) <= Date.parse("August 15th, #{e_year}")
        "00"
      else
        "10"
      end
    end

    def december_start_year
      if Date.today.month >= 9 && Date.today.month <= 12
        Date.today.year
      elsif Date.today.month >= 1 && Date.today.month <= 8
        Date.today.year - 1
      end
    end
  end
end
