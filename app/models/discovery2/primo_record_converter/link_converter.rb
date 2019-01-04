class Discovery2::PrimoRecordConverter::LinkConverter
  attr_reader :primo_link, :primo_record

  def initialize(primo_link, primo_record)
    @primo_link = primo_link
    @primo_record = primo_record
  end

  def link
    if @link.nil?
      @link = Discovery2::Record::Link.new
      copy_link_attributes(@link)
      set_link_title(@link)
    end
    @link
  end

  def institution
    primo_link.institution
  end

  private
    def valid_uri?
      if @valid_uri.nil?
        begin
          URIParser.call(link.url)
          @valid_uri = true
        rescue Addressable::URI::InvalidURIError => e
          @valid_uri = false
          text = "Bad URL on record. URL: #{link.url} "
          EventNotifier.notify(text, primo_record).deliver
        end
      end
      @valid_uri
    end

    def copy_link_attributes(link)
      link.url = primo_link.url
      link.notes = primo_link.notes
      link.source = primo_link.source
      link.service_type = primo_link.service_type
    end

    def set_link_title(link)
      if valid_uri?
        TitleHathitrust.convert(link, primo_record)
        TitlePurl.convert(link, primo_record)
        TitleDoi.convert(link, primo_record)
        TitleHdl.convert(link, primo_record)


        TitleDomain.convert(link, primo_record)
      else
        link.title = link.url
      end
    end

end
