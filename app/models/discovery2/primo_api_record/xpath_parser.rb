class Discovery2::PrimoAPIRecord::XpathParser
  attr_reader :xml

  def initialize(xml)
    @xml = xml
  end


  def get(section, key)
    xml.root.xpath("#{section}/#{key}").select { | r | r.inner_text.strip.present? }.collect { | r | r.inner_text.strip }
  end

end
