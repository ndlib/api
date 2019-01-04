class Discovery2::PrimoAPIRecord::SeriesTitleParser
  attr_accessor :serial_title

  def self.call(serial_title)
    self.new(serial_title).convert
  end


  def initialize(serial_title)
    @serial_title = serial_title
    validate!
  end


  def convert
    serial_title.collect do | f |
      split = split_tilda(f)
      {
        series_title: trim_end_semicolon(split[0]),
        series_volume: split[1]
      }

    end
  end

  private

    def validate!
      if !serial_title.is_a?(Array)
        raise "The serial_title must already be an array"
      end
    end


    def split_tilda(field)
      Discovery2::PrimoAPIRecord::FieldSplitter.tilda(field)
    end


    def trim_end_semicolon(title)
      title.strip.gsub(/;$/, '')
    end

end
