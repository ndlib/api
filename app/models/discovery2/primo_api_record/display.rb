class Discovery2::PrimoAPIRecord::Display
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def title
    get(:title)
  end

  def vernacular_title
    get(:vertitle)
  end

  def creator
    creator_array = parse_semicolon_delimited(get(:creator))
    data = ensure_array(creator_array)
    hierarchical_result(data)
  end

  def contributor
    contributor_array = parse_semicolon_delimited(get(:contributor))
    data = ensure_array(contributor_array)
    hierarchical_result(data)
  end

  def language
    ret = []
    ensure_array(get(:language)).each do |lang|
      ret = ret.concat(split_semicolon(lang))
    end

    ret
  end

  def language_note
    ensure_array(get(:lds05))
  end

  def biographical_note
    data = get(:lds04)
    ensure_array(data)
  end

  def citation
    ensure_array(get(:citation))
  end

  def general_notes
    data = get(:lds01)
    ensure_array(data)
  end

  def source
    get(:source)
  end

  def subjects
    subject_array = parse_semicolon_delimited(get(:subject))
    data = ensure_array(subject_array)
    hierarchical_result(data)
  end

  def series
    data = ensure_array(get(:lds30))
    Discovery2::PrimoAPIRecord::SeriesTitleParser.call(data)
  end

  def uniform_titles
    uniform_title_array = parse_semicolon_delimited(get(:lds31))
    data = ensure_array(uniform_title_array)
    hierarchical_result(data)
  end

  def description
    get(:description)
  end

  def contents
    ret = []

    ensure_array(get(:lds03)).each do | cont |
      ret = ret.concat(split_dash(cont))
    end

    ret
  end

  def edition
    get(:edition)
  end

  def publisher
    get(:publisher)
  end

  def creation_date
    get(:creationdate)
  end

  def coverage
    data = get(:coverage)
    ensure_array(data)
  end

  def format
    data = get(:format)
    ensure_array(data)
  end

  def rights
    data = get(:rights)
    ensure_array(data)
  end

  def is_part_of
    get(:ispartof)
  end

  def earlier_title
    parse_author_title(get(:lds20))
  end

  def later_title
    parse_author_title(get(:lds21))
  end

  def supplement
    parse_author_title(get(:lds22))
  end

  def supplement_to
    parse_author_title(get(:lds23))
  end

  def issued_with
    parse_author_title(get(:lds24))
  end

  def parallel_title
    get(:lds06)
  end

  def variant_title
    get(:lds07)
  end

  def to_hash
    {
      title: title,
      creator: creator,
      contributor: contributor,
      language: language,
      language_note: language_note,
      biographical_note: biographical_note,
      general_notes: general_notes,
      source: source,
      subjects: subjects,
      series: series,
      uniform_titles: uniform_titles,
      description: description,
      contents: contents,
      edition: edition,
      publisher: publisher,
      creation_date: creation_date,
      citation: citation,
      coverage: coverage,
      format: format,
      rights: rights,
      is_part_of: is_part_of,
      earlier_title: earlier_title,
      later_title: later_title,
      supplement: supplement,
      supplement_to: supplement_to,
      issued_with: issued_with,
      parallel_title: parallel_title,
      variant_title: variant_title


    }
  end

  private

    def get(field)
      xpath_parser.get(:display, field)
    end

    def xpath_parser
      @xpath_parser ||= Discovery2::PrimoAPIRecord::XpathParser.new(record.send(:xml))
    end

    def ensure_array(field)
      Discovery2::PrimoAPIRecord::EnsureArray.call(field)
    end

    def parse_semicolon_delimited(field)
      field_array = []
      if field.is_a?(Array)
        field.each do |field_string|
          field_array.concat(split_semicolon(field_string))
        end
      else
        field_array.concat(split_semicolon(field)) unless field.blank?
      end
      field_array
    end

    def split_semicolon(field)
      Discovery2::PrimoAPIRecord::FieldSplitter.semicolon(field)
    end

    def split_dash(field)
      Discovery2::PrimoAPIRecord::FieldSplitter.dash(field)
    end

    def hierarchical_result(field)
      Discovery2::PrimoAPIRecord::HierarchicalResult.call(field)
    end

    def parse_author_title(field)
      Discovery2::PrimoAPIRecord::AuthorTitleConverter.call(field)
    end

end
