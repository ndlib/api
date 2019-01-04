class Discovery2::PrimoRecordConverter::LinkConverter::EnsureProxiedLink
  attr_reader :link

  PROXIED_MAP = YAML::load_file(Rails.root.join('config', 'data', 'domain_should_be_proxied.yml')).stringify_keys

  def self.call(link)
    new(link).ensure_proxied
  end

  def initialize(link)
    @link = link
  end

  def ensure_proxied
    if url_not_proxied_and_should_be?
      link.url = prodixed_url
    end

    link
  end

  private

  def link_currently_proxied?
    link.url.match(/proxy\.library\.nd\.edu/)
  end

  def link_should_be_proxied?
    PROXIED_MAP[link.domain]
  end

  def url_not_proxied_and_should_be?
    !link_currently_proxied? && link_should_be_proxied?
  end

  def prodixed_url
    "https://proxy.library.nd.edu/login?url=#{link.url}"
  end
end
