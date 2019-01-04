class Resource::Primo::API
  # Primo search deep link: http://www.exlibrisgroup.org/display/PrimoOI/Brief+Search+%28Deep+Link%29
  SEARCH_DEEP_LINK = "/primo_library/libweb/action/dlSearch.do"
  # Make use of the Client-side API from https://developers.google.com/books/docs/dynamic-links
  GOOGLE_BOOKS_URL = "http://books.google.com/books"
  INSTITUTION_NAMES = {
    "NDU" => "University of Notre Dame",
    "NDLAW" => "Kresge Law Library",
    "BCI" => "Bethel College",
    "HCC" => "Holy Cross College",
    "SMC" => "Saint Mary's College"
  }
  SHORT_INSTITUTION_NAMES = {
    "NDU" => "Notre Dame",
    "HCC" => "Holy Cross",
    "SMC" => "Saint Mary's"
  }
  LIBRARY_NAMES = {
    "HESB" => "Hesburgh Library",
    "HCC" => "Holy Cross College",
    "SMC" => "Saint Mary's College",
    "CAMPR" => "Campus Resources"
  }
  PAGE_SIZE = 10
  attr_reader :search_term, :search_scope, :primo_url_query_hash, :primo_search_url_query_hash, :primo_record_url_query_hash, :primo_scope_query

  def initialize(search_term, search_scope)
    @search_term = search_term
    @search_scope = search_scope
    @primo_url_query_hash = {
      vid: self.class.institution,
      institution: self.class.institution,
      "vl(freeText0)" => search_term,
      query: "any,contains,#{search_term}",
      bulkSize: PAGE_SIZE,
      onCampus: true
    }
    @primo_search_url_query_hash = {}
    @primo_record_url_query_hash = {}

    add_search_terms

    self.send("scope_#{search_scope}")
  end

  def search
    if @search.nil?
      @search = Exlibris::Primo::Search.new(page_size: PAGE_SIZE)
      @search.on_campus
    end
    @search
  end

  def search_url
    "#{self.class.base_url}#{SEARCH_DEEP_LINK}?#{search_url_query}"
  end

  def institution
    "NDU"
  end

  def primo_url_query
    query = primo_url_query_hash.to_query
    # Highlighting multiple fields is done by adding multiple displayField parameters to the query
    query += "&highlight=true&displayField=title&displayField=creator"
    query
  end

  def search_url_query
    query = primo_url_query
    if primo_search_url_query_hash.present?
      query += "&#{primo_search_url_query_hash.to_query}"
    end
    "#{query}&#{{indx: 1}.to_query}"
  end

  def record_url_query
    query = primo_url_query
    if primo_record_url_query_hash.present?
      query += "&#{primo_record_url_query_hash.to_query}"
    end
    query
  end

  def size
    search.size
  end

  def display_size
    ActionController::Base.helpers.number_with_delimiter(size, delimiter: ',')
  end

  def records
    if @records.nil?
      @records = []
      search.records.each_with_index do |record, index|
        @records << Resource::Primo::APIRecord.new(record, self, index)
      end
    end
    @records
  end

  def google_bibkey_ids
    if @google_bibkey_ids.nil?
      @google_bibkey_ids = {}
      records.each do |record|
        bibkey = nil
        if record.oclc
          bibkey = "OCLC:#{record.oclc}"
        elsif record.lccn
          bibkey = "LCCN:#{record.lccn}"
        elsif record.isbn
          bibkey = "ISBN:#{record.isbn}"
        end
        if bibkey
          @google_bibkey_ids[bibkey] = record.id
        end
      end
    end
    @google_bibkey_ids
  end

  def google_bibkeys
    @google_bibkeys ||= google_bibkey_ids.keys
  end

  def google_books_url
    if google_bibkeys.present?
      query = {
        bibkeys: google_bibkeys.join(','),
        jscmd: 'viewapi',
        callback: 'googleBooksCallback'
      }.to_query
      "#{GOOGLE_BOOKS_URL}?#{query}"
    end
  end

  def google_books_hash
    if @google_books_hash.nil?
      @google_books_hash = {
        'ids' => google_bibkey_ids,
        'url' => google_books_url
      }
      @google_books_hash.delete_if {|k,v| v.blank?}
    end
    @google_books_hash
  end

  def to_hash
    if @to_hash.nil?
      @to_hash = {
        'size' => size,
        'display_size' => display_size,
        'search_term' => search_term,
        'search_scope'=> search_scope,
        'search_url' => search_url,
        'google_books' => google_books_hash,
        'records' => records_to_hash
      }
      @to_hash.delete_if {|k,v| v.blank?}
    end
    @to_hash
  end

  def to_json
    @to_json ||= to_hash.to_json
  end

  def records_to_hash
    records.collect{|record| record.to_hash}
  end

  def self.base_url
    primo_configuration["base_url"]
  end

  def self.institution
    primo_configuration["institution"]
  end

  def self.primo_configuration
    if @primo_configuration.nil?
      path = File.join(Rails.root, 'config', 'primo.yml')
      @primo_configuration = YAML.load_file(path)[Rails.env]
    end
    @primo_configuration
  end

  def self.institution_name(code)
    INSTITUTION_NAMES[code] || code
  end

  def self.short_institution_name(code)
    SHORT_INSTITUTION_NAMES[code] || code
  end

  def self.library_name(code)
    LIBRARY_NAMES[code] || code
  end

  private

    def add_search_terms
      if search_scope == 'id'
        if search_is_dedup_id?
          search.record_id! search_term
        else
          s = search_term.gsub(/^TN_/, '')
          search.add_query_term s, 'rid', 'exact'
        end
      elsif search_scope == 'record_id'
        search.record_id! search_term
      else
        search.any_contains search_term
      end
    end


    def add_scopes(scopes)
      scopes = scopes.collect{|scope| "scope:(#{scope})"}
      scopes.each do |scope|
        search.add_local_location(scope)
      end
      scopes
    end

    def add_primo_central_adaptor
      search.add_adaptor_location("primo_central_multiple_fe")
    end

    def scope_catalog
      scopes = add_scopes(%w(ndulawrestricted dtlrestricted NDU NDLAW ndu_digitool))
      @primo_url_query_hash.merge!({
        tab: 'nd_campus',
        search_scope: "nd_campus",
        loc: "local,#{scopes.join(',')}"
      })
    end

    def scope_electronic
      add_primo_central_adaptor()
      @primo_url_query_hash.merge!({
        tab: 'onesearch',
        search_scope: "malc_blended",
        loc: "adaptor,primo_central_multiple_fe"
      })
    end

    def scope_blended
      scopes = add_scopes(%w(NDU BCI HCC SMC NDLAW))
      add_primo_central_adaptor()
      @primo_url_query_hash.merge!({
        tab: 'onesearch',
        search_scope: "malc_blended"
      })
      @primo_search_url_query_hash = {
        loc: "local,#{scopes.join(',')},primo_central_multiple_fe"
      }
      @primo_record_url_query_hash = {
        loc: "adaptor,primo_central_multiple_fe",
      }
    end


    def scope_id
      search.add_location("local", "")

      # done to remove being too chatty with primo central when it
      # is clearly not needed.
      if !search_is_only_local?
        add_primo_central_adaptor()
        @primo_search_url_query_hash = {
          loc: "local,primo_central_multiple_fe"
        }
        @primo_record_url_query_hash = {
          loc: "adaptor,primo_central_multiple_fe",
        }
      end

      @primo_url_query_hash.merge!({
        tab: 'onesearch',
        search_scope: "malc_blended"
      })
    end

    def scope_record_id
      scope_id
    end


    def search_is_only_local?
      search_term.scan(/^TN_/).blank?
    end

    def search_is_dedup_id?
      search_term =~ /^dedupmrg/
    end
end
