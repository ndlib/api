class AnnexRequestFetcher

  attr_reader :outbound_dir, :inbound_dir, :archive_dir

  def initialize
    @outbound_dir = annex_configuration['aleph_outbound_dir']
    @inbound_dir = annex_configuration['aleph_inbound_dir']
    @archive_dir = annex_configuration['aleph_archive_dir']
  end

  def fetch_requests(type)
    files_to_parse(type).map { |path| parse_request(path) }
  end

  private

  def files_to_parse(type)
    [].tap do |array|
      dir = open_dir(type)
      dir.entries.each do |entry|
        path = File.join(dir.path, entry)
        if file_valid?(path)
          array.push path
        end
      end
    end
  end

  def annex_configuration
    if @annex_configuration.nil?
      path = File.join(Rails.root, 'config', 'annex.yml')
      @annex_configuration = YAML.load_file(path)[Rails.env]
    end
    @annex_configuration
  end

  def open_dir(dir)
    case dir
    when 'outbound'
      Dir.new(Rails.root + outbound_dir)
    when 'inbound'
      Dir.new(Rails.root + inbound_dir)
    when 'archive'
      Dir.new(Rails.root + archive_dir)
    end
  end

  def parse_request(file_path)
    Resource::Annex::Request.new(
      JSON.parse(
        File.open(
          file_path, mode: "r",
          external_encoding: "UTF-8",
          internal_encoding: "UTF-8" ).read
        )
      ).formatted
  end

  def file_valid?(file)
    valid_filename?(file) && File.file?(file) && valid_size?(file)
  end

  def valid_size?(file)
    size = File.size?(file)
    size && size > 0
  end

  def valid_filename?(file)
    File.basename(file) =~ /^[^.]/
  end

end
