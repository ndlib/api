class Person::Instructor::Course
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include SunspotHelper

  attr_accessor :netid, :term, :section_groups

  validates_presence_of :netid, :term


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  Sunspot.setup(self) do
    string :netid, :stored => true
    string :term, :stored => false, :multiple => false
    string :section_groups, :stored => true, :multiple => true
  end


  def id
    term + '_' + netid
  end


  def persisted?
    false
  end


  def self.index_instructed_courses(instructors, remove_existing_before_adding = false)
    instructor_group = Array.new
    instructors.keys.each do |instructor_id|
      instructor_data = instructors[instructor_id]
      instructor = self.new
      instructor.term = instructor_data[:term]
      instructor.netid = instructor_data[:netid]
      instructor_section_groups = Array.new
      instructor_data[:section_groups].keys.each do |section_group_id|
        instructor_section_groups.push(instructor_data[:section_groups][section_group_id][:unique_section_group_id])
      end
      instructor.section_groups = instructor_section_groups
      if instructor.valid?
        instructor_group.push(instructor)
      else
        instructor.index_exception
      end
    end

    if remove_existing_before_adding
      Sunspot.remove_all(self)
      Sunspot.commit
    end

    self.index(instructor_group)
  end


  private

  def self.sunspot_search(klass)
    Sunspot.new_search(klass)
  end


end
