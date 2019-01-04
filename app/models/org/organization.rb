class Org::Organization
  include HttpRequestHelper
  include LdapRequestHelper
  include CacheHelper

  attr_reader :id, :name, :people, :contact_information, :manager, :parent_org, :context

  def initialize(context = 'library', id = 'all')
    @id = id
    raise "Invalid context" if !valid_contexts.include?(context.to_sym)
    @context = context
  end

  def build_org
    directory_org = Rails.cache.fetch(directory_cache_key) do
      pull_from_staff_directory
    end
    parse_staff_directory_values(directory_org)
    contact_information(directory_org)
    self
  end

  def self.all_orgs_by_context(population_context)
    case population_context
    when 'library'
      o_all = self.new('library', 'all')
      directory_orgs = JSON.parse(self.http_get(self.build_uri('staff_directory_org', o_all)))
      orgs_list = Array.new
      parsed_org = nil
      directory_orgs.each do |o|
        org = self.new('library', o["unitID"])
        org.build_org
        parsed_org = JSON.parse(org.to_json)
        orgs_list.push(parsed_org)
      end
      orgs_list
    end
  end

  def contact_information(directory_org)
    @contact_information = Org::OrgContactInformation.new(:directory_org => directory_org)
  end

  def directory_cache_key
    "directory-#{self.class.base_cache_key}/#{@id}".gsub(/\s+/, "")
  end

  def valid_contexts
    {
      library:      {staff_directory:'id'}
    }
  end

  def pull_from_staff_directory
    begin
      directory_org = JSON.parse(self.class.http_get(self.class.build_uri('staff_directory_org', self)))
    rescue HttpRequestHelper::ResponseException => e
      Rails.logger.warn(time_stamp + " #{e.message}")
      @error_message = "#{e.message}"
      directory_org = nil
    end
    directory_org
  end

  def parse_staff_directory_values(directory_org)
    unless (directory_org.nil?)
      @staff_directory_id = directory_org["unitID"]
      @name = directory_org["unitName"]
    end
  end

  def time_stamp
    DateTime.now.strftime('%m-%d-%Y %I:%M:%S%p')
  end

end
