class Discovery2::SfxRequest::Target
  attr_reader :node, :data

  FIELD_NAMES = [:service_type, :target_name, :target_public_name, :target_url, :coverage_statement, :embargo_statement, :note, :timediff_warning]

  def initialize(node)
    @node = node
    @data = {}
  end

  FIELD_NAMES.each do |field|
    define_method(field) do
      get(field)
    end
  end

  def title
    target_public_name
  end

  def url
    target_url
  end

  def notes
    [coverage_statement, embargo_statement, note].compact
  end

  def source
    "SFX"
  end

  def link
    @link ||= Discovery2::Record::Link.from_object(self)
  end

  def to_hash
    link.to_hash
  end

  private

    def get(element_name)
      if !data.has_key?(element_name)
        element = node.xpath(".//#{element_name}").first
        if element
          value = element.content
          if value.blank?
            value = nil
          end
        else
          value = nil
        end
        data[element_name] = value
      end
      data[element_name]
    end


end
