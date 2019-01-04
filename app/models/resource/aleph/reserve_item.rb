class Resource::Aleph::ReserveItem
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  include SunspotHelper

  attr_accessor :bib_id, :sid, :doc_number, :section_group_id, :crosslist_id, :course_triple, :title, :publisher, :creator, :format

  validates_presence_of :bib_id, :doc_number


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  Sunspot.setup(self) do
    string :bib_id, :stored => true
    string :sid, :stored => true
    string :doc_number, :stored => true
    string :section_group_id, :stored => true
    string :crosslist_id, :stored => true
    string :title, :stored => true
    string :publisher, :stored => true
    string :creator, :stored => true
    string :format, :stored => true
    string :course_triple, :stored => true
  end


  def self.all_aleph_reserves
    aleph_reserves_search = sunspot_search(self)
    aleph_reserves_search.build do
      paginate :page => 1, :per_page => 10000
    end
    aleph_reserves_search.execute
    build_reserve_item_list(aleph_reserves_search.hits)
  end


  def self.build_reserve_item_list(aleph_reserves_hits)
    all_aleph_reserves = Array.new
    aleph_reserves_hits.each do |aleph_reserves_solr_hit|
      aleph_reserve_item = Hash.new
      aleph_reserve_item[:bib_id] = aleph_reserves_solr_hit.stored('bib_id')
      aleph_reserve_item[:sid] = aleph_reserves_solr_hit.stored('sid')
      aleph_reserve_item[:doc_number] = aleph_reserves_solr_hit.stored('doc_number')
      aleph_reserve_item[:section_group_id] = aleph_reserves_solr_hit.stored('section_group_id')
      aleph_reserve_item[:crosslist_id] = aleph_reserves_solr_hit.stored('crosslist_id')
      aleph_reserve_item[:course_triple] = aleph_reserves_solr_hit.stored('course_triple')
      aleph_reserve_item[:title] = aleph_reserves_solr_hit.stored('title')
      aleph_reserve_item[:publisher] = aleph_reserves_solr_hit.stored('publisher')
      aleph_reserve_item[:creator] = aleph_reserves_solr_hit.stored('creator')
      aleph_reserve_item[:format] = aleph_reserves_solr_hit.stored('format')
      all_aleph_reserves.push(aleph_reserve_item)
    end
    all_aleph_reserves
  end


  def self.item_status_by_doc_number(doc_number)
    item_list = Array.new
    status_xml = get_status_xml(doc_number)
    status_xml.xpath("//item-data").each do |item|
      item_hash = Hash.new
      item.elements.each do |element|
        item_hash[element.name] = element.content
      end
      item_list.push(build_item(item_hash))
    end
    item_list
  end


  def self.get_status_xml(doc_number)
    response = Net::HTTP.get_response(URIParser.call(aleph_xservices_item_status_url(doc_number)))
    Nokogiri::XML(response.body)
  end


  def self.aleph_xservices_item_status_url(doc_number)
    Rails.configuration.aleph_reserve_item_status.sub(/\<\<doc_number\>\>/, "#{Rack::Utils.escape(doc_number)}")
  end

  def self.build_item(item_hash)
    current_status = !item_hash['due-date'].blank? ? 'checked out' : 'available'
    {
      'loan_type' => item_hash['loan-status'],
      'primary_location' => item_hash['collection'],
      'secondary_location' => item_hash['sub-library'],
      'current_status' => current_status,
      'due_date' => item_hash['due-date'],
      'due_time' => item_hash['due-hour']
    }
  end


  def id
    sid
  end


  def self.find_section_group(course_triple, section_number)
    course = Resource::Course::Course.course('by_course_triple', course_triple)
    section_group_id = false
    crosslist_id = false
    if course
      course[:section_groups].each do |section_group|
        section_group[:sections].each do |section|
          if section[:section_number] == section_number
            section_group_id = section_group[:section_group_id]
            crosslist_id = section_group[:crosslist_id]
          end
        end
      end
    end
    [section_group_id, crosslist_id]
  end


  def persisted?
    false
  end


  def self.index_aleph_reserves(aleph_reserves)
    aleph_reserve_items = Array.new
    aleph_reserves.keys.each do |course_triple|
      aleph_reserves[course_triple].each do |reserve_item|
        if reserve_item.valid?
          aleph_reserve_items.push(reserve_item)
        else
          reserve_item.index_exception
        end
      end
    end
    self.index(aleph_reserve_items)
  end


  def self.sunspot_search(klass)
    Sunspot.new_search(klass)
  end

  private



end
