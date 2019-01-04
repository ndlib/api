class Discovery2::PrimoRecordConverter::LinkConverter::TitleDoi < Discovery2::PrimoRecordConverter::LinkConverter::Title

  DOI_MAP = YAML::load_file(Rails.root.join('config', 'data', 'doi_title.yml')).stringify_keys

  def matches?
    doi_link? && link.title.nil?
  end


  def title
    if DOI_MAP.present? && title = DOI_MAP[parse_doi_id]
      @title = title
    else
      text = "Missing title for doi id, #{parse_doi_id},  URL: #{link.url} "
      EventNotifier.notify(text, primo_record).deliver
      nil
    end
  end


  def set_title
    link.title = title
  end

  private


    def doi_link?
      search_url.present?
    end


    def parse_doi_id
      search_url.captures.first
    end


    def search_url
      if @matched_url.nil?
        url = Discovery2::PrimoAPIRecord::UrlIsProxy.new().parse_out_proxy_url(link.url)
        @matched_url = url.match(/^https?:\/\/[dx.]?doi[.]org\/(10[.][0-9]*)\/?/)
      end

      @matched_url
    end
end
