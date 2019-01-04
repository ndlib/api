class Discovery2::PrimoRecordConverter::AdditionalLinkConverter
  attr_reader :link_hash, :link_key

  def initialize(link_hash, link_key)
    @link_hash = link_hash
    @link_key = link_key
  end

  def link
    @link ||= build_link
  end

  def title
    display_title || determine_title
  end

  def display_title
    format_title(get(:display))
  end

  def format_title(title_string)
    if title_string.present?
      title_string.gsub(/^.*{ (.+) }$/, '\1')
    else
      nil
    end
  end

  def determine_title
    if link_key == 'linktoreview'
      "Review"
    elsif link_key == 'linktofa'
      "Full description / Finding Aid"
    else
      "Additional Link"
    end
  end

  private
    def get(key)
      link_hash[key.to_sym]
    end

    def determine_institution
      get(:record_id).to_s[0,3]
    end

    def build_link
      Discovery2::Record::Link.new.tap do |link|
        copy_link_attributes(link)
      end
    end

    def copy_link_attributes(link)
      link.url = get(:url)
      link.source = "Primo"
      link.service_type = link_key
      link.title = title
    end
end
