class Discovery2::Sources::Sources
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def to_hash
    ret = []
    record_source_ids.each do | record_id |
      obj = Discovery2::Sources::Source.new(record_id, record)
      if obj.include_this_source?
        ret << Discovery2::Sources::Source.new(record_id, record).to_hash
      end
    end
    ret
  end

  def record_source_ids
    record_source_ids = record_ids
    # add in the primo central as a source id
    if (record.recordid =~ /^TN_/).present?
      record_source_ids << record.recordid
    end

    record_source_ids
  end

  private

  def record_ids
    @record_ids ||= xpath_parser.get(:display, :lds02)
  end

  def get(field)
    xpath_parser.get(:addata, field)
  end


  def xpath_parser
    @xpath_parser ||= Discovery2::PrimoAPIRecord::XpathParser.new(record.send(:xml))
  end
end
