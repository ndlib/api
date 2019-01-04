require "addressable/uri"

class URIParser
  attr_reader :uri

  def initialize(uri)
    @uri = uri
  end

  def parse
    Addressable::URI.parse(uri)
  end

  def self.call(uri)
    parser = new(uri)
    parser.parse
  end
end
