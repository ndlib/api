class Resource::Course::Section
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include SunspotHelper

  attr_accessor :section_id, :instructors, :course_title, :course_triple, :term, :alpha_prefix, :number, :section_number, :crn, :supersection_id, :enrollments, :combined


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  Sunspot.setup(self) do
    string :section_id, :stored => true
    string :instructors, :stored => true, :multiple => true
    text :course_title, :stored => true
    string :course_triple, :stored => true
    string :term, :stored => true
    string :alpha_prefix, :stored => true
    integer :number, :stored => true
    integer :section_number, :stored => true
    string :crn, :stored => true
    string :supersection_id, :stored => true
    string :enrollments, :stored => true, :multiple => true
    text :combined, :stored => true
  end


  def id
    section_id
  end


  def persisted?
    false
  end


  def self.section_search(section_search_criteria, search_term = nil)
    section_group_results = Array.new
    section_search = sunspot_search(self)
    sections = get_sections_by_search(section_search, section_search_criteria, search_term)

    sections.each do |section|
      section_group = Resource::Course::SectionGroup.section_group(section.stored('section_id'), 'section_id')
      section_group_results.push(section_group) unless ( section_group_results.include?(section_group) || section_group.blank? )
    end
    section_group_results
  end


  def self.get_sections_by_search(section_search, section_search_criteria, search_term)
    section_search.build do
      fulltext section_search_criteria do
        fields(:course_title, :combined => 4.0)
      end
      if !search_term.nil? && !search_term.empty?
        with(:term, search_term)
      end
    end
    section_search.execute
    section_search.hits
  end

  def self.section(id)
    section_search = sunspot_search(self)
    section_search.build do
      with(:section_id, id)
    end
    section_search.execute
    if section_search.total >= 1
      section = build_section(section_search)
    else
      section = []
    end

    section
  end


  def self.build_section(search)
    section = search.hits.first

    {
      section_id: section.stored('section_id'),
      supersection_id: section.stored('supersection_id'),
      instructors: instructor_persons(section.stored('instructors')),
      term: section.stored('term'),
      course_triple: section.stored('course_triple'),
      course_title: section.stored('course_title'),
      alpha_prefix: section.stored('alpha_prefix'),
      number: section.stored('number'),
      section_number: section.stored('section_number'),
      crn: section.stored('crn'),
      enrollments: enrollment_netids(section.stored('enrollments'))
    }
  end


  def self.enrollment_netids(enrollments)
    enrolled_netids = Array.new
    unless enrollments.blank?
      enrollments.each do |enrollment_id|
        enrollment_id =~ /\d+_(.+)/
        enrolled_netids.push($1)
      end
    end
    enrolled_netids
  end

  def self.instructor_persons(instructors)
    instructor_list = Array.new
    instructor_netids(instructors).each do |netid|
      instructor_list.push(person_build(netid))
    end
    instructor_list
  end


  def self.instructor_netids(instructors)
    instructor_netids = Array.new
    unless instructors.blank?
      instructors.each do |instructor_id|
        instructor_id =~ /\d+_(.+)/
        instructor_netids.push($1)
      end
    end
    instructor_netids
  end


  def self.index_sections(sections, remove_existing_before_adding = false)
    section_group = Array.new
    sections.keys.each do |section_id|
      section_data = sections[section_id]
      section = self.new
      section.section_id = section_id
      section.instructors = section_data[:instructors]
      section.term = section_data[:term]
      section.course_title = section_data[:course_title]
      section.course_triple = section_data[:term] + '_' + section_data[:alpha_prefix] + '_' + section_data[:number]
      section.alpha_prefix = section_data[:alpha_prefix]
      section.number = section_data[:number]
      section.section_number = section_data[:section_number]
      section.crn = section_data[:crn]
      section.supersection_id = section_data[:supersection_id]
      section.enrollments = section_data[:enrollments]
      combined_keyword = section_data[:course_title] + ' ' + section.term + ' ' + section.alpha_prefix + ' ' + section.number + ' ' + build_instructor_string(section.instructors)
      combined_keyword.strip!
      section.combined = combined_keyword
      if section.valid?
        section_group.push(section)
      else
        section.index_exception
      end
    end

    if remove_existing_before_adding
      Sunspot.remove_all(self)
      Sunspot.commit
    end

    self.index(section_group)
  end


  private


  def self.sunspot_search(klass)
    Sunspot.new_search(klass)
  end


  def self.prep_person(p)
    p.build_person
    JSON.parse(p.to_json)
  end


  def self.person_build(id)
    p = Person::Base.new('by_netid', id)
    prep_person(p)
  end


  def self.build_instructor_string(instructors)
    person_string = String.new
    unless instructors.blank?
      instructors.each do |instructor|
        netid = extract_netid(instructor)
        p = Person::Base.new('by_netid', netid)
        p.build_person
        unless p.first_name.blank?
          person_string = person_string + ' ' + p.first_name + ' ' + p.last_name
        end
      end
    end
    person_string.blank? ? ' ' : person_string.strip!
  end


  def self.extract_netid(instructor)
    instructor =~ /\d+_(.+)/
    return $1
  end

end
