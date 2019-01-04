class Discovery2::PrimoRecordConverter
  attr_reader :primo_record, :record

  def initialize(primo_record)
    @primo_record = primo_record
    if primo_record.present?
      @record = Discovery2::Record.new
    end
  end

  def convert
    if primo_record.present?
      convert_id
      convert_type
      convert_primo
      convert_display
      convert_identifiers
      convert_holdings
      convert_sources
      convert_links
      convert_sfx_links
      convert_openurl_query
      record
    else
      nil
    end
  end

  def convert_id
    record.id = primo_record.id
  end

  def convert_type
    record.type = primo_record.type
  end

  def convert_primo
    record.primo = primo_record.record.to_hash["record"]
  end

  def convert_display
    record.display = primo_record.display.to_hash
  end

  def convert_identifiers
    record.identifiers = primo_record.identifiers.to_hash
  end

  def convert_holdings
    record.holdings = primo_record.holdings.collect { | h | h.to_hash }
  end

  def convert_sources
    record.sources = primo_record.sources.to_hash.collect { | s | s.to_hash }
  end

  def convert_links
    LinksConverter.convert_links(primo_record, record.online_access)
  end

  def convert_sfx_links
    SFXLinksConverter.convert(primo_record, record.online_access)
  end

  def convert_openurl_query
    record.openurl_query = primo_record.openurl_query.to_query
  end

  def self.convert(primo_record)
    converter = new(primo_record)
    converter.convert
    converter.record
  end
end
