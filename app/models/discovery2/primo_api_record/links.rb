class Discovery2::PrimoAPIRecord::Links
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def fulltext_links
    @fulltexts ||= Discovery2::PrimoAPIRecord::FulltextLink.fulltexts(record)
  end

  def record_findtext_link
    @record_findtext_link ||= fulltext_links.detect{|l| l.link_to_findtext_for_current_institution? }
  end

  def fulltext_links_hash
    fulltext_links.collect { | l | l.to_hash }
  end

  def table_of_contents_links
    @toc_links ||= Discovery2::PrimoAPIRecord::FulltextLink.tables_of_contents(record)
  end

  def table_of_contents_links_hash
    table_of_contents_links.collect { | l | l.to_hash }
  end

  def request_links_links
    @rl_links ||= Discovery2::PrimoAPIRecord::FulltextLink.request_links(record)
  end

  def request_links_links_hash
    request_links_links.collect { | l | l.to_hash }
  end

  def sfx_request
    @sfx_request ||= Discovery2::SfxRequest.new(openurl_query, 'ndu')
  end

  def sfx_request_hash
    sfx_request.to_hash
  end

  def openurl_query_object
    @openurl_query_object ||= Discovery2::PrimoAPIRecord::OpenUrlQuery.new(record)
  end

  def openurl_query
    if record_findtext_link.present?
      record_findtext_link.query
    else
      openurl_query_object.to_query
    end
  end

  def empty_institution_hash
    {
      fulltext: [],
      table_of_contents: [],
      request_links: [],
      findtext: nil,
      ill: nil,
      report_a_problem: nil
    }
  end

  def debug_hash
    if @debug_hash.nil?
      @debug_hash = {}
      @debug_hash[:cataloged_findtext_query] = record_findtext_link.present? ? record_findtext_link.query : nil
      @debug_hash[:generated_findtext_query] = openurl_query_object.to_query
    end
    @debug_hash
  end

  def add_link_to_hash(institution, link_type, link)
    if link.present?
      @to_hash[institution] ||= empty_institution_hash
      if @to_hash[institution][link_type].is_a?(Array)
        if !@to_hash[institution][link_type].detect{|l| Discovery2::Record::Link.urls_are_the_same?(link.url, l[:url])}
          @to_hash[institution][link_type] << link.to_hash
        end
      else
        @to_hash[institution][link_type] = link.to_hash
      end
    end
  end

  def add_sfx_links_to_hash
    add_link_to_hash(sfx_request.institution, :findtext, sfx_request.findtext_link_hash)
    sfx_request.fulltext_links.each do |link|
      add_link_to_hash(sfx_request.institution, :fulltext, link)
    end
    sfx_request.table_of_contents_links.each do |link|
      add_link_to_hash(sfx_request.institution, :table_of_contents, link)
    end
    add_link_to_hash(sfx_request.institution, :ill, sfx_request.ill_link)
    add_link_to_hash(sfx_request.institution, :report_a_problem, sfx_request.report_a_problem_link)
  end

  def add_primo_links_to_hash
    fulltext_links.each do |link|
      # Do not add the cataloged findtext link to the fulltext links
      if !link.link_to_findtext_for_current_institution?
        add_link_to_hash(link.institution, :fulltext, link)
      end
    end
    table_of_contents_links.each do |link|
      add_link_to_hash(link.institution, :table_of_contents, link)
    end
  end


  def to_hash
    if @to_hash.nil?
      @to_hash = {}

      add_sfx_links_to_hash()
      add_primo_links_to_hash()

      if Rails.env.development?
        @to_hash[:debug] = debug_hash
      end
    end
    @to_hash
  end

end
