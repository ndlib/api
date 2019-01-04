class Discovery2::PrimoAPI
  INSTITUTION_CODES = ["NDU", "BCI", "SMC", "HCC"]
  attr_reader :search_term, :search_scope, :institution_code

  def initialize(search_term, search_scope, institution_code = "NDU")
    @search_term = search_term
    @institution_code = format_institution_code(institution_code)
    by_id(search_term)
  end

  def format_institution_code(code)
    default_code = "NDU"
    if search_is_primo_central?
      code = code.to_s.upcase
      if !INSTITUTION_CODES.include?(code)
        code = default_code
      end
    else
      code = default_code
    end
    code
  end

  def by_id(id)
    @search_scope = 'id'

    add_search_terms

    self.send("scope_#{search_scope}")
  end


  def search
    if @search.nil?
      @search = Exlibris::Primo::Search.new(page_size: 1, institution: institution_code)
      @search.on_campus
    end
    @search
  end

  def records
    if @records.nil?
      @records = []
      search.records.each_with_index do |record, index|
        @records << Discovery2::PrimoAPIRecord.new(record, self, index)
      end
    end
    @records
  end

  def to_hash
    if @to_hash.nil?
      @to_hash = records_to_hash
    end

    @to_hash
  end

  def to_json
    @to_json ||= to_hash.to_json
  end

  def records_to_hash
    records.collect{|record| record.to_hash}
  end

  private

    def add_search_terms
      if search_is_primo_central?
        s = search_term.gsub(/^TN_/, '')
        search.add_query_term s, 'rid', 'exact'
      elsif search_is_record_id?
        search.record_id! search_term
      else
        search.add_query_term search_term, 'rid', 'exact'
      end
    end


    def add_primo_central_adaptor
      search.add_adaptor_location("primo_central_multiple_fe")
    end


    def scope_id
      # done to remove being too chatty with primo central when it
      # is clearly not needed.
      if search_is_primo_central?
        add_primo_central_adaptor()
      else
        search.add_location("local", "")
        add_scopes(%w(NDU BCI HCC SMC NDLAW))
      end
    end

    def add_scopes(scopes)
      scopes = scopes.collect{|scope| "scope:(#{scope})"}
      scopes.each do |scope|
        search.add_local_location(scope)
      end
      scopes
    end

    def search_is_primo_central?
      search_term.scan(/^TN_/).present?
    end

    def search_is_record_id?
      search_term =~ /^dedupmrg|^hathi_pub|^crlcat|^([a-z]+_aleph)/
    end
end
