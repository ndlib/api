class Discovery2::PrimoRecordConverter::LinkConverter::TitleHdl < Discovery2::PrimoRecordConverter::LinkConverter::Title

  HDL_MAP = YAML::load_file(Rails.root.join('config', 'data', 'hdl_title.yml')).stringify_keys

  def matches?
    hdl_link? && link.title.nil?
  end

  def title
    if HDL_MAP.present? && title = HDL_MAP[parse_hdl_id]
      @title = title
    else
      text = "Missing title for hdl id, #{parse_hdl_id},  URL: #{link.url} "
      EventNotifier.notify(text, primo_record).deliver
      nil
    end
  end

  def set_title
    link.title = title
  end

  private

    def hdl_link?
      search_url.present?
    end


    def parse_hdl_id
      id = search_url.captures.first
      if id == '2027'
        id = parse_id_for_university_of_michigan
      end

      id
    end


    def search_url
      if @matched_url.nil?
        url = Discovery2::PrimoAPIRecord::UrlIsProxy.new().parse_out_proxy_url(link.url)
        @matched_url = url.match(/^https?:\/\/hdl[.]handle[.]net\/([0-9.]*)\/(.*)\/?/)
      end

      @matched_url
    end

    # the id is heb in http://hdl.handle.net/2027/heb.00022
    def parse_id_for_university_of_michigan
      id = search_url.captures[1]
      id = id.split('.').first

      if HDL_MAP[id]  # use the id if it is in the mappings
        id
      else
        '2027'
      end
    end
end
