class Discovery2::PrimoRecordConverter::LinksConverter
  attr_reader :primo_record, :record_links

  def initialize(primo_record, record_links)
    @primo_record = primo_record
    @record_links = record_links
  end

  def get_institution(institution_code)
    record_links.institution(institution_code)
  end

  def link_converter_institution(link_converter)
    get_institution(link_converter.institution)
  end

  def convert_links
    convert_fulltext_links
    convert_table_of_contents_links
    convert_additional_links
    convert_request_links_links
  end

  def primo_links
    primo_record.links
  end

  def convert_additional_links
    Discovery2::PrimoRecordConverter::AdditionalLinksConverter.convert(primo_record, record_links)
  end

  def convert_fulltext_links
    primo_links.fulltext_links.each do |primo_link|
      convert_fulltext_link(primo_link)
    end
  end

  def convert_fulltext_link(primo_link)
    converter = link_converter(primo_link)
    institution = link_converter_institution(converter)
    add_fulltext_link(converter.link, institution)
    converter
  end

  def add_fulltext_link(link, institution)
    institution.add_fulltext_link(link)
  end

  def convert_table_of_contents_links
    primo_links.table_of_contents_links.each do |primo_link|
      converter = link_converter(primo_link)
      link_converter_institution(converter).add_table_of_contents_link(converter.link)
    end
  end

  def convert_request_links_links
    primo_links.request_links_links.each do |primo_link|
      link = convert_request_links(primo_link)
      link_converter_institution(primo_link).add_request_links_link(link)
    end
  end

  def link_converter(primo_link)
    Discovery2::PrimoRecordConverter::LinkConverter.new(primo_link, primo_record)
  end

  def convert_request_links(primo_link)
    link = Discovery2::Record::Link.new
    link.url = primo_link.url
    link.notes = primo_link.notes
    link.source = primo_link.source
    link.service_type = primo_link.service_type
    link.title = primo_link.record.display

    link
  end



  def self.convert_links(primo_record, record_links)
    converter = new(primo_record, record_links)
    converter.convert_links
    record_links
  end
end
