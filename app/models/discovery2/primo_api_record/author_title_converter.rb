class Discovery2::PrimoAPIRecord::AuthorTitleConverter

  attr_reader :field

  def self.call(field)
    self.new(field).convert
  end


  def initialize(field)
    @field = field
    validate!
  end


  def convert
    ret = []
    field.each do | row |
      ret << convert_row(row)
    end

    ret
  end


  private

    def validate!
      if !field.is_a?(Array)
        raise "The field must already be an array"
      end
    end


    def validate_parsed_row!(parser)
      if parser.get('A').present? && parser.get('T').empty?
        text = "Other titles has author field without a title field, #{parser.original_string}"
        EventNotifier.notify(text)
      end
    end


    def convert_row(row)
      if subfield.has_subfields?(row)
        parser = subfield.new(row)

        validate_parsed_row!(parser)

        {
          author: parser.get('A'),
          title: parser.get('T')
        }
      else
        {
          title: row,
          author: ''
        }
      end
    end


    def subfield
      Discovery2::PrimoAPIRecord::Subfield
    end


end
