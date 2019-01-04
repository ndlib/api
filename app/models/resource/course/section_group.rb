class Resource::Course::SectionGroup
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include SunspotHelper

  attr_accessor :sections, :crosslist_id, :section_group_id, :primary_instructor


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  Sunspot.setup(self) do
    string :sections, :stored => true, :multiple => true
    string :section_group_id, :stored => true
    string :crosslist_id, :stored => true, :multiple => false
    string :primary_instructor, :stored => true
  end


  def id
    section_group_id
  end


  def persisted?
    false
  end


  def self.section_group(id, request_type='section_id')
    section_group_search = build_search(id, request_type)
    section_group_search.execute
    if section_group_search.total >= 1
      section_group = build_section_group(section_group_search.hits.first)
    end

    section_group
  end

  def self.build_search(id, request_type)
    section_group_search = sunspot_search(self)
    case request_type
    when 'section_group_id'
      section_group_search.build do
        with(:section_group_id, id)
      end
    when 'crosslist_id'
      section_group_search.build do
        with(:crosslist_id, id)
      end
    else
      section_group_search.build do
        with(:sections, id)
      end
    end
    section_group_search
  end

  def self.section_groups(id)
    Benchmark.bm do |x|
      search = ''
    x.report("sunsport") { search = sunspot_search(self) }
    search.build do
      with(:crosslist_id, id)
    end
    x.report("search") { search.execute }
    section_groups = Array.new
    if search.total >= 1
      x.report("hits") {
      search.hits.each do |hit|
        section_groups.push(build_section_group(hit))
      end
      }
    else
      section_groups = []
    end

    return section_groups
    end
  end


  def self.build_section_group(section_group)
    section_list = Array.new
    section_group.stored('sections').each do |section_id|
      section = Resource::Course::Section.section(section_id)
      section_list.push(section)
    end

    {
      section_group_id: section_group.stored('section_group_id'),
      primary_instructor: person_build(section_group.stored('primary_instructor')),
      sections: section_list,
      crosslist_id: section_group.stored('crosslist_id')
    }
  end

  def self.index_section_groups(section_groups, remove_existing_before_adding = false)
    section_group_group = Array.new
    section_groups.keys.each do |section_group_id|
      section_group_data = section_groups[section_group_id]
      section_group = self.new
      section_group.section_group_id = section_group_id
      section_group.sections = section_group_data[:sections]
      section_group.crosslist_id = section_group_data[:crosslist_id]
      section_group.primary_instructor = section_group_data[:primary_instructor]
      if section_group.valid?
        section_group_group.push(section_group)
      else
        section_group.index_exception
      end
    end

    if remove_existing_before_adding
      Sunspot.remove_all(self)
      Sunspot.commit
    end


    self.index(section_group_group)
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

end
