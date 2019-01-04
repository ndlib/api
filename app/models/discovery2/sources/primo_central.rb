class Discovery2::Sources::PrimoCentral
  attr_reader :record_id, :record

  def initialize(record_id, record)
    @record_id = record_id
    @record = record
  end

  def self.can_process_record?(record_id)
    (record_id =~ /^TN_/).present?
  end

  def id
    record_id
  end

  def source_id
    record_id
  end

  def url
    if (backlink)
      @url ||= ParseBacklinkUrl.new(backlink).parse
    else
      ""
    end
  end

  def type
    "primo_central"
  end

  def title
    if url.present?
      title_domain.title
    else
      "#{source_id}"
    end
  end

  def include_this_source?
    return true if backlink.present?
    false
  end

  private

  def backlink
    @backlink ||= get(:backlink)
    if @backlink.nil?
      nil
    end
    @backlink.first
  end

  def get(field)
    xpath_parser.get(:links, field)
  end

  def xpath_parser
    @xpath_parser ||= Discovery2::PrimoAPIRecord::XpathParser.new(record.send(:xml))
  end

  def title_domain
    os  = OpenStruct.new  # needed because of how the title domain is coupled.
    # could be refactored so that the class to determine the title is different from the one that is used to do the link conversion.
    os.url = url

    Discovery2::PrimoRecordConverter::LinkConverter::TitleDomain.new(os, record)
  end

  class ParseBacklinkUrl
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def parse
      url.match(/(https?:\/\/.*)/)[1].gsub(/\$\$.*$/, '')
    end
  end

end
