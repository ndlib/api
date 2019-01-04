class Discovery2::PrimoAPIRecord::UrlIsProxy
  PROXY_PATTERNS = [
    /(^http[s]?:\/\/((login[.])?proxy[.]library[.]nd[.]edu))/,
    /(^http[s]?:\/\/(smcproxy1[.]saintmarys[.]edu([:]2048)?))/,
    /(^http[s]?:\/\/(bcezproxy[.]bethelcollege[.]edu))/,
  ]
  def self.call(url)
    self.new.is_proxy?(url)
  end

  def is_proxy?(url)
    return false if url.nil?
    # see tests for matches
    PROXY_PATTERNS.any?{ |pattern| url.match(pattern) }
  end

  def parse_out_proxy_url(url)
    return "" if url.nil?

    pattern = /[?][q]?url=(.*)$/
    if is_proxy?(url)
      url.match(pattern).captures.first
    else
      url
    end
  end
end
