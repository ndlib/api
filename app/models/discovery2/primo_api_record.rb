class Discovery2::PrimoAPIRecord
  attr_reader :record, :search, :index

  def initialize(record, search_instance = nil, index = 0)
    @record = record
  end

  def id
    get(:control_recordid)
  end

  def type
    get(:display_type)
  end

  def identifiers
    @identifiers ||= Discovery2::PrimoAPIRecord::Identifiers.new(record)
  end

  def display
    @display ||= Discovery2::PrimoAPIRecord::Display.new(record)
  end

  def holdings
    if @holdings.nil?
      @holdings = record.holdings.collect { | h | Discovery2::PrimoAPIRecord::Holding.new(h) }
    end
    @holdings
  end

  def links
    @links ||= Discovery2::PrimoAPIRecord::Links.new(record)
  end

  def openurl_query
    @openurl_query ||= Discovery2::PrimoAPIRecord::OpenUrlQuery.new(record)
  end

  def sources
    @sources ||= Discovery2::Sources::Sources.new(record)
  end

  def to_hash
    {
        id: id,
        type: type,
        openurl_query: openurl_query,
        identifiers: identifiers.to_hash,
        display: display.to_hash,
        links: links.to_hash,
        holdings: holdings.collect{ | h | h.to_hash },
        sources: sources.to_hash,
        primo: record.to_hash["record"],
      }
  end

  def to_xml
    to_hash.to_xml
  end

  def to_json
    to_hash.to_json
  end

  private

    def get(field)
      if record.respond_to?(field)
        record.send(field)
      end
    end

    def ensure_array(data)
      Discovery2::PrimoAPIRecord::EnsureArray.call(data)
    end
end
