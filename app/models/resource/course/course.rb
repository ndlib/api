class Resource::Course::Course
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include SunspotHelper

  attr_accessor :course_id, :course_title, :term_prefix, :alpha_prefix, :number, :term, :instructors, :section_groups, :supersections, :combined

  validates_presence_of :course_title, :alpha_prefix, :number, :term


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  Sunspot.setup(self) do
    text :course_title, :stored => true
    string :term_prefix, :stored => true
    string :alpha_prefix, :stored => true
    integer :number, :stored => true
    string :term, :stored => false
    string :instructors, :stored => true, :multiple => true
    string :section_groups, :stored => true, :multiple => true
    string :supersections, :stored => true, :multiple => true
    text :combined, :stored => true
  end


  def id
    course_id
  end


  def self.course_section_search(course_search_criteria, search_term = nil)
    course_results = Array.new
    section_groups = Resource::Course::Section.section_search(course_search_criteria, search_term)
    section_groups.each do |section_group_result|
      course_results.push(build_course_by_section_group(section_group_result))
    end
    course_results
  end


  def self.course_search(course_search_criteria, search_term = nil)
    course_results = Array.new
    course_search = sunspot_search(self)
    courses = get_courses_by_search(course_search, course_search_criteria, search_term)
    courses.each do |course_result|
      course_results.push(build_course(course_result))
    end
    course_results
  end


  def self.get_courses_by_search(course_search, course_search_criteria, search_term)
    course_search.build do
      fulltext course_search_criteria do
        fields(:course_title, :combined => 4.0)
      end
      if !search_term.nil? && !search_term.empty?
        with(:term_prefix, search_term)
      end
    end
    course_search.execute
    course_search.hits
  end


  def self.course(query_type, course_criteria)
    course_search = sunspot_search(self)
    course_result = course_filter(query_type, course_search, course_criteria)
    if course_result.blank?
      return nil
    else
      if query_type == 'by_crosslist'
        return course_result
      else
        build_course(course_result)
      end
    end
  end


  def self.course_filter(query_type, course_search, course_criteria)
    course_results = nil
    case query_type
    when 'by_course_id'
      course_results = get_course_by_id(course_search, course_criteria)
    when 'by_course_triple'
      course_results = get_course_by_id(course_search, course_criteria)
    when 'by_section'
      course_results = get_course_by_section(course_search, course_criteria)
    when 'by_section_group'
      course_results = get_course_by_section_group(course_search, course_criteria)
    when 'by_supersection'
      course_results = get_course_by_supersection(course_search, course_criteria)
    when 'by_crosslist'
      courses = get_courses_by_crosslist(course_search, course_criteria)
      if courses.blank?
        return nil
      else
        course_results = courses.collect { |c| build_course(c) }
      end
    end
    course_results
  end


  def self.get_course_by_id(course_search, course_criteria)
      course_term, course_alpha, course_number = course_criteria.split('_')
      course_search.build do
        with(:term_prefix, course_term)
        with(:alpha_prefix, course_alpha)
        with(:number, course_number)
      end
      course_search.execute
      course_search.hits.first
  end


  def self.get_course_by_section(course_search, course_criteria)
    section_group = Resource::Course::SectionGroup.section_group(course_criteria, 'section_id')
    course_search.build do
      with(:section_groups, section_group[:section_group_id])
    end
    course_search.execute
    course_search.hits.first
  end


  def self.get_course_by_section_group(course_search, course_criteria)
    section_group = Resource::Course::SectionGroup.section_group(course_criteria, 'section_group_id')
    course_search.build do
      with(:section_groups, section_group[:section_group_id])
    end
    course_search.execute
    course_search.hits.first
  end


  def self.get_course_by_supersection(course_search, course_criteria)
    course_search.build do
      with(:supersections, course_criteria)
    end
    course_search.execute
    course_search.hits.first
  end


  def self.get_courses_by_crosslist(course_search, course_criteria)
    section_groups =""
    Benchmark.bm do |x|
      x.report("GROUPS") { section_groups = Resource::Course::SectionGroup.section_groups(course_criteria) }
    end

    if section_groups.blank?
      return nil
    else
      course_search.build do
        with(:section_groups, section_groups.collect { |section_group| section_group[:section_group_id] })
      end
      course_search.execute
      course_search.hits
    end
  end


  def self.build_course_by_section_group(section_group)
    return nil if section_group.blank?
    course_build = Hash.new
    sample_section_data = section_group[:sections].first
    course_build[:term_prefix] = sample_section_data[:term]
    course_build[:alpha_prefix] = sample_section_data[:alpha_prefix]
    course_build[:number] = sample_section_data[:number]
    course_build[:course_title] = sample_section_data[:course_title]
    course_build[:section_groups] = Array.new
    course_build[:section_groups].push(section_group)
    course_build
  end


  def self.build_course(course)
    course_build = Hash.new
    course_build[:term_prefix] = course.stored('term_prefix')
    course_build[:alpha_prefix] = course.stored('alpha_prefix')
    course_build[:number] = course.stored('number')
    course_build[:course_title] = course.stored('course_title')
    course_build[:section_groups] = Array.new
    return nil if course.blank?
    course.stored('section_groups').each do |section_group_id|
      section_group = Resource::Course::SectionGroup.section_group(section_group_id, 'section_group_id')
      course_build[:section_groups].push(section_group)
    end
    course_build[:supersections] = course.stored('supersections')
    course_build
  end


  def self.enrolled_courses(term, id, request_type='netid')
    enrolled_courses = Array.new
    enrolled_sections = []
    enrollment_search = build_enrollment_search(id, term, request_type)
    enrollment_search.execute
    if enrollment_search.total >= 1
      enrolled_sections = enrolled_sections?(enrollment_search)
    end

    enrolled_sections.each do |section_id|
      enrolled_course = build_enrolled_course(section_id)
      if !enrolled_course.blank?
        enrolled_courses.push(build_enrolled_course(section_id))
      end
    end
    enrolled_courses
  end

  def self.build_enrollment_search(id, term, request_type)
    enrollment_search = sunspot_search(Person::Student::Enrollment)
    if request_type == 'netid'
      enrollment_search.build do
        with(:netid, id)
        with(:term, term)
      end
    end
  end


  def self.enrolled_sections?(enrollment_search)
    enrollment_search.hits.first.stored('term_crn') || []
  end


  def self.build_enrolled_course(section_id)
    section = Resource::Course::Section.section(section_id)
    section_group = Resource::Course::SectionGroup.section_group(section_id)
    if !section_group.blank?
      crosslist_id = section_group[:crosslist_id]
      course = {
        course_id: section[:course_triple],
        crosslist_id: crosslist_id,
        course_title: section[:course_title],
        section_groups: section_group
      }
    else
      course = nil
    end
    return course
  end


  def self.instructed_courses(term, id, request_type='netid')
    instructed_courses = Array.new
    instructed_section_groups = []
    instruction_search = build_instruction_search(id, term, request_type)
    instruction_search.execute

    if instruction_search.total >= 1
      instructed_section_groups = instruction_search.hits.first.stored('section_groups')
    end

    instructed_section_groups.each do |section_group_id|
      instructed_courses.push(build_instructed_course(section_group_id))
    end

    instructed_courses
  end

  def self.build_instruction_search(id, term, request_type)
    instruction_search = sunspot_search(Person::Instructor::Course)
    if request_type == 'netid'
      instruction_search.build do
        with(:netid, id)
        with(:term, term)
      end
    end
    instruction_search
  end


  def self.build_instructed_course(section_group_id)
    section_group = Resource::Course::SectionGroup.section_group(section_group_id, 'section_group_id')
    sections = section_group[:sections]
    first_section = sections[0]
    course = {
      course_id: first_section[:course_triple],
      crosslist_id: section_group[:crosslist_id],
      course_title: first_section[:course_title],
      section_groups: section_group
    }
  end


  def persisted?
    false
  end


  def self.index_courses(courses, remove_existing_before_adding = false)

      course_group = Array.new
      courses.keys.each do |course_id|
          course_data = courses[course_id]
          course = self.new
          course_data[:unique_id] =~ /(\d+)_(\w+)_(\d+)/
          course.course_id = course_data[:unique_id]
          course.term_prefix = $1
          course.term = $1
          course.alpha_prefix = $2
          course.number = $3
          course.course_title = course_data[:title]
          course.instructors = course_data[:instructors]
          course.section_groups = course_data[:section_groups]
          course.supersections = course_data[:supersections]
          combined_keyword = ""
          combined_keyword = course_data[:title] + ' ' + course.term_prefix + ' ' + course.alpha_prefix + ' ' + course.number + ' ' + build_instructor_string(course.instructors)
          combined_keyword.strip!
          course.combined = combined_keyword
          if course.valid?
            course_group.push(course)
          else
            course.index_exception
          end
        end

      if remove_existing_before_adding
        Sunspot.remove_all(self)
        Sunspot.commit
      end

      self.index(course_group)
  end

  private

  def self.sunspot_search(klass)
    Sunspot.new_search(klass)
  end


  def self.build_instructor_string(instructors)
    person_string = String.new
    instructors.each do |instructor|
      netid = extract_netid(instructor)
      p = Person::Base.new('by_netid', netid)
      p.build_person
      unless p.first_name.blank?
        person_string = person_string + ' ' + p.first_name + ' ' + p.last_name
      end
    end
    person_string.blank? ? ' ' : person_string.strip!
  end


  def self.extract_netid(instructor)
    instructor =~ /\d+_(.+)/
    return $1
  end

end
