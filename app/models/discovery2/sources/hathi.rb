class Discovery2::Sources::Hathi
  attr_reader :record_id, :record

  def initialize(record_id, record)
    @record_id = record_id
    @record = record
  end

  def self.can_process_record?(original_id)
    (original_id =~ /^hathi_pub/).present?
  end

  def id
    record_id
  end

  def type
    "hathi"
  end

  def url
    "http://catalog.hathitrust.org/Record/#{source_id}"
  end

  def source_id
    @source_id ||= record_id.gsub(/^[^-]+-/, '')
  end

  def title
    "#{I18n.t("institutions.#{type}")}: #{source_id}"
  end

  def include_this_source?
    true
  end  
end
