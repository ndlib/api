class Discovery2::PrimoAPIRecord::HierarchicalResult
  attr_reader :field

  def self.call(field)
    self.new(field).convert
  end


  def initialize(field)
    @field = field
    validate!
  end


  def convert
    {
      fulltext: @field,
      hierarchical: parse_heirarchies
    }
  end


  private

    def parse_heirarchies
      @field.collect { | f | split_dash(f) }
    end


    def validate!
      if !field.is_a?(Array)
        raise "The field must already be an array"
      end
    end


    def split_dash(field)
      Discovery2::PrimoAPIRecord::FieldSplitter.dash(field)
    end
end
