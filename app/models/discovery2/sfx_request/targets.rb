class Discovery2::SfxRequest::Targets
  attr_reader :xml
  SERVICE_TYPES = [:getFullTxt, :getSelectedFullTxt, :getMessageNoFullTxt, :getTOC, :getHolding, :getDocumentDelivery, :getDOI, :getReference, :getWebService]

  def initialize(xml)
    @xml = xml
  end

  def xml_targets
    if xml
      @xml_targets ||= xml.xpath('//target')
    else
      []
    end
  end

  def to_hash
    if @to_hash.nil?
      @to_hash = {}
      links_by_service_type.each do |service_type, links|
        @to_hash[service_type] = links.collect{|l| l.to_hash}
      end
    end
    @to_hash
  end

  def targets
    @targets ||= load_targets
  end

  def service_type(key)
    links_by_service_type[key]
  end

  def links_by_service_type
    if @links_by_service_type.nil?
      @links_by_service_type = {}
      SERVICE_TYPES.each do |service_type|
        @links_by_service_type[service_type] = []
      end
      targets.each do |target|
        @links_by_service_type[target.service_type.to_sym] ||= []
        @links_by_service_type[target.service_type.to_sym] << target.link
      end
    end
    @links_by_service_type
  end

  def load_targets
    targets_array = []
    xml_targets.each do |node|
      targets_array << Discovery2::SfxRequest::Target.new(node)
    end
    targets_array
  end
end
