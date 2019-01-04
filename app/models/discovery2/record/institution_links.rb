class Discovery2::Record::InstitutionLinks
  attr_accessor :findtext, :ill, :report_a_problem
  attr_reader :institution_code, :fulltext, :table_of_contents, :finding_aids, :request_links

  def initialize(institution_code)
    @institution_code = institution_code
    @table_of_contents = Discovery2::Record::LinkArray.new
    @finding_aids = Discovery2::Record::LinkArray.new
    @request_links = Discovery2::Record::LinkArray.new
    @fulltext ||= Discovery2::Record::LinkArray.new
  end

  def add_fulltext_link(link)
    fulltext << link
  end

  def add_table_of_contents_link(link)
    table_of_contents << link
  end

  def add_finding_aid_link(link)
    finding_aids << link
  end

  def add_request_links_link(link)
    request_links << link
  end

  def links_to_hash(links)
    links.collect{|l| link_hash(l)}
  end

  def link_hash(link)
    if link.present?
      link.to_hash
    else
      nil
    end
  end

  def to_hash
    if @to_hash.nil?
      @to_hash = {
        id: institution_code,
        request_links: links_to_hash(request_links),
        fulltext: links_to_hash(fulltext),
        table_of_contents: links_to_hash(table_of_contents),
        finding_aids: links_to_hash(finding_aids),
        findtext: link_hash(findtext),
        ill: link_hash(ill),
        report_a_problem: link_hash(report_a_problem)
      }
    end
    @to_hash
  end

  def to_json
    to_hash.to_json
  end

end
