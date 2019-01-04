class Discovery2::PrimoAPIRecord::Identifiers
  attr_reader :record

  def initialize(record)
    @record = record
  end


  def isbn
    @isbn ||= get(:isbn)
  end


  def issn
    @issn ||= get(:issn)
  end


  def eissn
    @eissn ||= get(:eissn)
  end


  def doi
    @doi ||= get(:doi)
  end


  def pmid
    @pmid ||= get(:pmid)
  end


  def lccn
    @lccn ||= get(:lccn)
  end


  def oclc
    @oclc ||= get(:oclcid)
  end


  def record_ids
    @record_ids ||= xpath_parser.get(:display, :lds02)
  end


  def to_hash
   {
      isbn: isbn,
      issn: issn,
      eissn: eissn,
      doi: doi,
      pmid: pmid,
      lccn: lccn,
      oclc: oclc,
      record_ids: record_ids
    }
  end

  private

    def get(field)
      xpath_parser.get(:addata, field)
    end


    def xpath_parser
      @xpath_parser ||= Discovery2::PrimoAPIRecord::XpathParser.new(record.send(:xml))
    end
end
