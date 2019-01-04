class Discovery2::Record::Link
  attr_accessor :url, :title, :notes, :service_type, :source

  def initialize
    @notes = []
  end

  def to_hash
    ensure_proxied_link!

    {
      url: url,
      title: title,
      notes: notes,
      service_type: service_type,
      source: source
    }
  end

  def base_url
    @base_url ||= self.class.base_url(url)
  end

  def url_equals(other_url)
    base_url == self.class.base_url(other_url)
  end

  def findtext?
    host == 'findtext.library.nd.edu'
  end

  def parsed_url
    @parsed_url ||= URIParser.call(url)
  end

  def path
    parsed_url.path
  end

  def host
    parsed_url.host
  end

  def domain
    @domain ||= ::PublicSuffix.parse(host).domain
  end

  def query
    parsed_url.query
  end

  def ensure_proxied_link!
    Discovery2::PrimoRecordConverter::LinkConverter::EnsureProxiedLink.call(self)
  end

  def self.base_url(url)
    url = url.gsub(/.*proxy\.library\.nd\.edu\/login\?url=/,'')
    url = url.gsub(/\/$/,'')
    url
  end

  def self.urls_are_the_same?(url1, url2)
    base_url(url1) == base_url(url2)
  end

  def self.from_object(object)
    link = self.new
    link.title = object.title
    link.url = object.url
    link.notes = object.notes
    link.service_type = object.service_type
    link.source = object.source
    link
  end

end
