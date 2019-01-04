class Discovery2::PrimoAPIRecord::FieldSplitter


  def self.dash(field)
    self.new(field).split('--')
  end


  def self.semicolon(field)
    self.new(field).split(';')
  end


  def self.tilda(field)
    self.new(field).split('~~')
  end

  def initialize(field)
    @field = field
  end


  def split(delimiter)
    if @field.present?
      @field.split(delimiter).collect{ | r | r.to_s.strip }.reject { | r | r.empty? }
    else
      @field
    end
  end
end
