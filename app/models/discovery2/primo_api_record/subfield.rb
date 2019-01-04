class Discovery2::PrimoAPIRecord::Subfield
  attr_reader :original_string, :fields

  def self.has_subfields?(string)
    (string =~ /^\${2}/).present?
  end

  def initialize(string)
    @original_string = string
    @fields = parse(string)
  end

  def get(field)
    if @fields[field]
      @fields[field].strip
    else
      ""
    end
  end


  private

    def parse(string)
      Hash[string.scan(/\${2}([^\$])([^\$]+)/)]
    end


end
