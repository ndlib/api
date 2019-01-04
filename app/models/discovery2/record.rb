class Discovery2::Record
  attr_accessor :id, :type, :openurl_query, :institution_code, :links, :identifiers, :display, :holdings, :sources, :primo, :openurl_query

  def initialize
    @links = {}
    @identifiers = {}
    @openurl_query = {}
    @display = {}
    @holdings = []
    @sources = []
    @primo = {}
  end

  def online_access
    @online_access ||= self.class::Links.new
  end

  def to_hash
    if @to_hash.nil?
      @to_hash = {}
      [:id, :type, :institution_code, :display, :identifiers, :sources, :holdings, :openurl_query].each do |field|
        @to_hash[field] = send(field)
      end
      @to_hash[:online_access] = online_access.to_hash
      [:primo].each do |field|
        @to_hash[field] = send(field)
      end
    end
    @to_hash
  end

  def to_json
    to_hash.to_json
  end
end
