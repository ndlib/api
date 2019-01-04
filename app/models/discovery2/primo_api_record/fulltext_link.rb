require 'uri/http'

class Discovery2::PrimoAPIRecord::FulltextLink
  TRANSLATE_INSTITUTION_NAMES = {
    "Notre Dame" => "ndu",
    "Law" => "ndlaw",
    "Bethel" => "bci",
    "Holy" => "hcc",
    "Saint" => "smc"
  }

  attr_reader :record, :parent_record

  def self.fulltexts(record)
    record.fulltexts.collect { | h | self.new(h, record) }
  end

  def self.tables_of_contents(record)
    record.tables_of_contents.collect { | h | self.new(h, record) }
  end

  def self.request_links(record)
    record.request_links.collect { | h | self.new(h, record) }
  end

  def initialize(record, parent_record = nil)
    @record = record
    @parent_record = parent_record
  end

  def parent_title
    parent_display.title.first
  end

  def parent_display
    @parent_display ||= Discovery2::PrimoAPIRecord::Display.new(parent_record)
  end

  def record_id
    record.original_id
  end

  def url
    record.url
  end

  def title
    if match_hathi?
      'HathiTrust'
    elsif match_eresource?
      parent_title
    else
      parse_url_for_title
    end
  end

  def institution
    if record.institution
      record.institution
    elsif inst = institution_from_display
      inst
    else
      current_institution
    end
  end

  def current_institution
    "ndu"
  end

  def is_current_institution?
    institution == current_institution
  end

  def link_to_findtext?
    (url =~ %r{^http://findtext.library.nd.edu}).present?
  end

  def link_to_findtext_for_current_institution?
    is_current_institution? && link_to_findtext?
  end

  def parsed_url
    @parsed_url ||= URIParser.call(url)
  end

  def query
    parsed_url.query
  end

  def service_type
    if match_hathi?
      'HathiTrust'
    elsif match_eresource?
      'Database'
    elsif match_proxy?
      'ProxyUrl'
    else
      'LinkToRsrc'
    end
  end

  def source
    'Primo'
  end

  def link
    @link ||= Discovery2::Record::Link.from_object(self)
  end

  def to_hash
    link.to_hash
  end


  def notes
    if @notes.nil?
      @notes = []
      if record.display
        @notes << parse_notes(record.display)
      end
      @notes.compact!
    end
    @notes
  end


  private

    def institution_from_display
      if code = record.display_code
        code.scan(/ndu|ndlaw|bci|hcc|smc/).first
      elsif code = record.display
        inst = code.scan(/Notre Dame|Law|Bethel|Holy|Saint/).first
        TRANSLATE_INSTITUTION_NAMES[inst]
      else
        nil
      end
    end


    def match_hathi?
      @match_hathi = Discovery2::PrimoAPIRecord::UrlIsHathiTrust.call(url)
    end


    def match_proxy?
      @match_proxy = Discovery2::PrimoAPIRecord::UrlIsProxy.call(url)
    end


    def match_eresource?
      @match_eresource = Discovery2::PrimoAPIRecord::UrlIsEresource.call(url)
    end

    def parse_out_proxy_url
      Discovery2::PrimoAPIRecord::UrlIsProxy.new.parse_out_proxy_url(url)
    end


    def parse_url_for_title
      title = url
      if match_proxy?
        title = parse_out_proxy_url
      end
      title = get_domain_name(title)
      title = title.gsub(/http[s]?:\/\//, '')
      title = title.split('.')

      "#{title[title.size - 2]}.#{title[title.size - 1]}"
    end


    def parse_notes(search_title)
      if match = search_title.match(/\{(.*)\}/)
        match[1].strip
      else
        nil
      end
    end

    def get_domain_name(url)
      URIParser.call(url).host
    end


end
