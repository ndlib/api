class Discovery2::PrimoRecordConverter::AdditionalLinksConverter
  attr_reader :primo_record, :record_links

  LINK_MAP = {
    'linktorequest' => :request_links,
    'linktotoc' => :table_of_contents,
    'linktofa' => :finding_aids,
    'linktoreview' => :reviews,
    'addlink' => :add_links,
  }

  def initialize(primo_record, record_links)
    @primo_record = primo_record
    @record_links = record_links
  end

  def original_record
    primo_record.record
  end

  def original_links(key)
    original_record.send(:links, key)
  end

  def convert
    LINK_MAP.each do |original_key, new_key|
      convert_links(original_key, new_key)
    end
  end

  def convert_links(original_key, new_key)
    add_links(new_key, converted_links(original_key))
  end

  def converted_links(original_key)
    original_links(original_key).collect{|link_hash| convert_link(link_hash, original_key)}
  end

  def convert_link(link_hash, original_key)
    link_converter(link_hash, original_key).link
  end

  def links(key)
    record_links.send(key)
  end

  def add_links(key, new_links)
    links(key).merge(new_links)
  end

  def link_converter(link_hash, original_key)
    Discovery2::PrimoRecordConverter::AdditionalLinkConverter.new(link_hash, original_key)
  end

  def self.convert(primo_record, record_links)
    converter = new(primo_record, record_links)
    converter.convert
    record_links
  end
end
