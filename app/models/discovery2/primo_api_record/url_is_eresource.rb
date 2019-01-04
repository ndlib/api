class Discovery2::PrimoAPIRecord::UrlIsEresource

  def self.call(url)
    self.new.is_eresource?(url)
  end

  def is_eresource?(url)
    url.to_s.match(/^http:\/\/eresources[.]/)
  end

end
