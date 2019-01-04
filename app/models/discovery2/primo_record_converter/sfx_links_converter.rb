class Discovery2::PrimoRecordConverter::SFXLinksConverter
  attr_reader :primo_record, :record_links

  def initialize(primo_record, record_links)
    @primo_record = primo_record
    @record_links = record_links
  end

  def convert
    convert_sfx_links
    create_sfx_links
  end

  def convert_sfx_links
    record_links.institutions.each do |institution|
      convert_sfx_link(institution)
    end
  end

  def convert_sfx_link(institution)
    if link = find_existing_link(institution)
      institution.findtext = sfx_link(link)
      remove_fulltext_link(link, institution)
    end
  end

  def find_existing_link(institution)
    institution.fulltext.detect{|l| Discovery2::Record::SFXLink.findtext?(l) }
  end

  def remove_fulltext_link(link, institution)
    institution.fulltext.delete(link)
  end

  def sfx_link(link)
    Discovery2::Record::SFXLink.new(link)
  end

  def primo_openurl_query
    primo_record.openurl_query
  end

  def openurl_query
    primo_openurl_query.to_query
  end

  def get_institution(institution_code)
    record_links.institution(institution_code)
  end

  def malc_institution_codes
    ['ndu','bci','smc','hcc']
  end

  def malc_institutions
    malc_institution_codes.collect{|code| get_institution(code)}
  end

  def create_sfx_links
    malc_institutions.each do |institution|
      create_sfx_link(institution)
    end
  end

  def build_base_link(institution)
    sfx_request(institution).link
  end

  def sfx_request(institution)
    Discovery2::SfxRequest.new(openurl_query, institution.institution_code)
  end

  def create_sfx_link(institution)
    if institution.findtext.blank?
      link = build_base_link(institution)
      institution.findtext = sfx_link(link)
    end
  end

  def self.convert(primo_record, record_links)
    converter = new(primo_record, record_links)
    converter.convert
  end

end
