class Discovery2::PrimoAPIRecord::EnsureArray
  attr_reader :data

  def self.call(data)
    self.new(data).ensure_array
  end

  def initialize(data)
    @data = data
  end

  def ensure_array
    if @data.nil?
      []
    elsif !@data.is_a?(Array)
      @data = [@data]
    else
      @data
    end
  end

end
