class Discovery2::BaseRecordRequest
  include CacheHelper

  attr_reader :id, :search, :institution_code

  def initialize(id, institution_code = nil)
    @id = id
    if institution_code.blank?
      institution_code = 'ndu'
    end
    @institution_code = Discovery2::Institution.format_code(institution_code)
  end

  def institution
    @institution ||= Discovery2::Institution.new(institution_code)
  end

  def to_json
    @to_json ||= to_hash.to_json
  end

  def api_object
    @api_object ||= Discovery2::PrimoAPI.new(id, 'id', institution_code)
  end

  def api_record
    api_object.records.first
  end

  def converter
    if @converter.nil?
      @converter = Discovery2::PrimoRecordConverter.new(api_record)
      @converter.convert
    end
    @converter
  end

  def record
    if @record.nil?
      @record = converter.record
      if @record.present?
        @record.institution_code = institution_code
        process_record(@record)
      end
    end
    @record
  end

  def process_record(record)
  end

  def records
    @records ||= [ record ].compact
  end

  def records_hash
    records.collect{|r| r.to_hash}
  end

  def expires_in
    if Rails.env.development?
      5.seconds
    else
      30.minutes
    end
  end

  def search
    @search ||= Rails.cache.fetch(cache_key, :expires_in => expires_in) do
      record.to_hash
    end

    @search
  end

  def to_hash
    @to_hash ||= {
      records: records_hash
    }
  end

  def to_xml
    api_object.search.search.to_xml
  end

  def links
    @links ||= self.class::Links.new(self)
  end

  def cache_key
    "#{self.class.base_cache_key}/#{institution_code}/#{id}".gsub(/\s+/, "-")
  end

end
