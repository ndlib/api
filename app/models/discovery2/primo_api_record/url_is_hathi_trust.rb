class Discovery2::PrimoAPIRecord::UrlIsHathiTrust

  def self.call(url)
    self.new.is_hathi?(url)
  end

  def is_hathi?(url)
    url.to_s.match(/^http:\/\/catalog[.]hathitrust/)
  end

end
