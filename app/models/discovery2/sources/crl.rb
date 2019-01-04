class Discovery2::Sources::CRL
  attr_reader :record_id, :record

  def initialize(record_id, record)
    @record_id = record_id
    @record = record
  end

  def self.can_process_record?(record_id)
    (record_id =~ /^crlcat[.]/).present?
  end

  def id
    record_id
  end

  def source_id
    @crl_number ||= record_id.match(/^crlcat[.](.*).+$/)[1]
  end

  def url
    "http://catalog.crl.edu/record=#{source_id}"
  end

  def type
    "crl"
  end

  def title
    "#{I18n.t("institutions.#{type}")}: #{source_id}"
  end

  def include_this_source?
    true
  end    
end
