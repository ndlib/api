class Discovery2::PrimoRecordConverter::LinkConverter::TitleDomain < Discovery2::PrimoRecordConverter::LinkConverter::Title

  DOMAIN_MAP = YAML::load_file(Rails.root.join('config', 'data', 'domain_title.yml')).stringify_keys

  def matches?
    link.title.blank?
  end

  def title
    if @title.nil?
      @title = nil
      domains.each do |domain|
        @title ||= self.class.domain_title(domain)
      end
      @title ||= display_domain
    end
    @title
  end

  def display_domain
    domain = split_domain.last(2).join('.')
    # if it is calling this then we are showing the spit domain as a title.
    text = "The domain, #{domain}, does not have a label."
    if primo_record.respond_to?(:id)
      EventNotifier.notify(text, primo_record).deliver
    else
      EventNotifier.notify(text, nil).deliver
    end

    domain
  end

  def domains
    if @domains.nil?
      @domains = split_domain.map.with_index{|d,i| split_domain[i,split_domain.length - i].join('.') }
      # Remove the top level domain since "com" won't match to a title
      @domains.delete(@domains.last)
    end
    @domains
  end

  def split_domain
    if unproxied_host.present?
      unproxied_host.split('.')
    else
      []
    end
  end

  def unproxied_host
    parsed_url.host
  end

  def parsed_url
    @parsed_url ||= URIParser.call(original_url)
  end

  def original_url
    Discovery2::PrimoAPIRecord::UrlIsProxy.new.parse_out_proxy_url(link.url)
  end

  def set_title
    link.title = title
  end

  def self.domain_title(domain)
    if DOMAIN_MAP.present?
      DOMAIN_MAP[domain]
    else
      nil
    end
  end
end
