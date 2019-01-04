class Discovery2::Institution
  attr_reader :code

  def initialize(code)
    @code = self.class.format_code(code)
  end

  def self.format_code(code)
    code.to_s.downcase
  end
end
