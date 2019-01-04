class Discovery2::PrimoAPIRecord::GoogleBooksUrl

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def bibkey
    if indentifiers.oclc.first
      "OCLC:#{indentifiers.oclc.first}"
    elsif indentifiers.lccn.first
      "LCCN:#{indentifiers.lccn.first}"
    elsif indentifiers.isbn.first
      "ISBN:#{indentifiers.isbn.first}"
    end
  end


  private


    def indentifiers
      @identifiers ||= Discovery2::PrimoAPIRecord::Identifiers.new(record)
    end


end
