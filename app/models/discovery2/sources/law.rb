class Discovery2::Sources::Law
  attr_reader :record_id, :record

  def initialize(record_id, record)
    @record_id = record_id
    @record = record
  end

  def self.can_process_record?(record_id)
    (record_id =~ /^ndlaw_iii\./).present?
  end

  def id
    record_id
  end

  def source_id
    @source_id ||= id.gsub(/^ndlaw_iii\./, '')
  end

  def url
    "http://innopac.law.nd.edu/record=#{source_id}*eng"
  end

  def type
    "ndlaw"
  end

  def title
    "#{I18n.t("institutions.#{type}")}: #{source_id}"
  end

  def include_this_source?
    true
  end
end
