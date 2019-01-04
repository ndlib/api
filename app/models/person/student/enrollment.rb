class Person::Student::Enrollment
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include SunspotHelper

  attr_accessor :netid, :term_crn, :term

  validates_presence_of :netid, :term

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  Sunspot.setup(self) do
    string :netid, :stored => true
    string :term_crn, :stored => true, :multiple => true
    string :term, :stored => false, :multiple => false
  end


  def id
    term + '_' + netid
  end


  def to_json(options = {})
    data.to_json
  end


  def persisted?
    false
  end


  def self.index_enrollments(students, remove_existing_before_adding = false)
    return if (students.nil?)
    
    student_group = Array.new
    students.keys.each do |student_id|
      student_data = students[student_id]
      student = self.new
      student.term = student_data[:term]
      student.netid = student_data[:netid]
      student.term_crn = student_data[:enrollments]
      if student.valid?
        student_group.push(student)
      else
        student.index_exception
      end
    end

    if remove_existing_before_adding
      Sunspot.remove_all(self)
      Sunspot.commit
    end

    self.index(student_group)
  end

  private


  def self.sunspot_search(klass)
    Sunspot.new_search(klass)
  end

end
