class Discovery2::Sources::Aleph
  attr_reader :record_id, :record

  def initialize(record_id, record)
    @record_id = record_id
    @record = record
  end

  def self.can_process_record?(record_id)
    (record_id =~ /_aleph/).present?
  end

  def id
    record_id
  end

  def url
    direct_url
  end

  def type
    @type ||= id.gsub(/_.*/,'')
  end

  def source_id
    @source_id ||= system_number
  end

  def title
    "#{I18n.t("institutions.#{type}")}: #{source_id}"
  end

  def include_this_source?
    true
  end    

  private

  def system_number
    id.gsub(/[^\d]+/,'')
  end

  def local_base
    "#{type}01pub"
  end

  def host
    "https://aleph1-2010.library.nd.edu"
  end

  def direct_path
    "/F/?func=direct&doc_number=#{system_number}&local_base=#{local_base}"
  end

  def direct_url
    "#{host}#{direct_path}"
  end

end
