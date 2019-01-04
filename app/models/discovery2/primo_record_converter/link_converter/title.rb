class Discovery2::PrimoRecordConverter::LinkConverter::Title
  attr_reader :link, :primo_record

  delegate :host, :path, to: :link

  def initialize(link, primo_record)
    @link = link
    @primo_record = primo_record
  end

  def convert
    if matches?
      set_title
    end
  end

  def matches?
    raise "#matches? not implemented"
  end

  def set_title
    raise "#set_title not implemented"
  end

  def self.convert(link, primo_record)
    converter = new(link, primo_record)
    converter.convert
    converter.link
  end
end
