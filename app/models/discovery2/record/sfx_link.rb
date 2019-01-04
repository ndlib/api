class Discovery2::Record::SFXLink
  attr_reader :link
  attr_accessor :targets_loaded, :number_of_targets

  delegate :title, :notes, :service_type, :source, :host, :path, :query, to: :link

  def initialize(link)
    @link = link
    @targets_loaded = false
    @number_of_targets = 0
  end

  def to_hash
    link.to_hash.merge({
      url: url,
      targets_loaded: targets_loaded,
      number_of_targets: number_of_targets
    })
  end

  def url
    if link.url =~ /\/ndu(_|%5F)local[?]/
      separator = link.url[-1] == '&' ? '' : '&'
      "#{link.url}#{separator}sid=ND:Primo"
    else
      link.url
    end
  end

  def self.findtext?(link)
    begin
      link.host == 'findtext.library.nd.edu'
    rescue
      false
    end
  end
end
