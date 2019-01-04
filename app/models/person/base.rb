class Person::Base
  include HttpRequestHelper
  include LdapRequestHelper
  include CacheHelper

  attr_accessor :id, :staff_directory_id, :identifier, :first_name, :last_name, :contact_information, :positions, :netid, :email, :full_name, :ndguid, :campus_department, :position_title, :phone

  # example routes
  # /1.1/people/by_id/23.json
  # /1.1/people/by_netid/rfox2.xml
  # /1.1/people/by_netid/rfox2.json
  # /1.1/people/by_id/23.xls
  # /1.1/people/by_id/23.csv
  # /1.1/people/all/library.json
  def initialize(identifier = 'by_netid', id = 'all')
    @id = id
    raise "Invalid identifier" if !valid_identifiers.include?(identifier.to_sym)
    @identifier_contexts = identifier_context(identifier)
    @identifier = identifier
  end

  def build_person(with_staff_directory=false)
    ldap_person = build_ldap_person

    directory_person = nil
    if(with_staff_directory)
      directory_person = build_directory_person
    end

    contact_information(ldap_person, directory_person)
    self
  end

  def build_ldap_person
    ldap_person = Rails.cache.fetch(ldap_cache_key) do
      pull_from_ldap
      # ldap_person = ldap_get(@identifier_contexts[:ldap],@id)
    end
    parse_ldap_values(ldap_person)

    ldap_person
  end

  def build_directory_person
    directory_person = Rails.cache.fetch(directory_cache_key) do
      pull_from_staff_directory
    end
    parse_staff_directory_values(directory_person)

    directory_person
  end

  def person_search
    results = ldap_get('uid', @id, 'disjoined')
    results.map { |person|
      p = { uid: get_attribute(person, 'uid'),
            first_name: get_attribute(person, 'givenname'),
            last_name: get_attribute(person, 'sn'),
            full_name: get_attribute(person, 'displayname')
          }
      JSON.parse(p.to_json) } if !results.blank?
  end

  def get_attribute(person, attr)
      JSON.parse(person.to_json)['myhash'][attr].first
  end

  def self.all_people_by_context(population_context)
    case population_context
    when 'library'
      p_all = Person::Base.new('by_netid', 'all')
      directory_people = JSON.parse(self.http_get(self.build_uri('staff_directory_person', p_all)))
      people_list = Array.new
      directory_people.each do |p|
        begin
          netid = p["netID"]
          netid.gsub!(/\s/, '')
          p = Person::Base.new('by_netid', netid)
          p.build_person(true)
          person = JSON.parse(p.to_json)
          people_list.push(person)
        rescue Exception => e
          Rails.logger.warn(DateTime.now.to_s + "[ERROR RAISED] #{e.message}")
        end
      end
      people_list
    end
  end

  def self.prime_cache
    self.all_people_by_context('library')
    return 0
  end

  def contact_information(ldap_person, directory_person)
    @contact_information = ::Person::ContactInformation.new(:ldap_person => ldap_person, :directory_person => directory_person)
  end

  def positions
    @positions
  end

  private

  def ldap_cache_key
    "ldap-#{self.class.base_cache_key}/#{@id}".gsub(/\s+/, "")
  end

  def directory_cache_key
    "directory-#{self.class.base_cache_key}/#{@id}".gsub(/\s+/, "")
  end

  def valid_identifiers
    {
      by_id:      {ldap:'ndguid',staff_directory:'id'},
      by_netid:   {ldap:'uid',staff_directory:'email'}
    }
  end

  def pull_from_staff_directory
    begin
      directory_person = JSON.parse(self.class.http_get(self.class.build_uri('staff_directory_person', self)))
    rescue HttpRequestHelper::ResponseException => e
      Rails.logger.warn(time_stamp + " #{e.message}")
      directory_person = nil
    end
    directory_person
  end

  def pull_from_ldap
    # begin
      ldap_person = ldap_get(@identifier_contexts[:ldap],@id)
    # rescue Exception => e
      # Rails.logger.warn(time_stamp + " [ERROR] Error contacting ldap: #{e.message}")
      # ldap_person = nil
    # end
    ldap_person
  end

  def parse_ldap_values(ldap_person)
    if (ldap_person)
      @netid = ldap_person.uid.first if ldap_person.respond_to?(:uid)
      @first_name = ldap_person.givenname.first if ldap_person.respond_to?(:givenname)
      @last_name = ldap_person.sn.first if ldap_person.respond_to?(:sn)
      @full_name = ldap_person.displayname.first if ldap_person.respond_to?(:displayname)
      @ndguid = ldap_person.ndguid.first if ldap_person.respond_to?(:ndguid)
      @position_title = ldap_person.ndtitle.first if ldap_person.respond_to?(:ndtitle)
      @campus_department = ldap_person.nddepartment.first if ldap_person.respond_to?(:nddepartment)
      @primary_affiliation = ldap_person.ndprimaryaffiliation.first if ldap_person.respond_to?(:ndprimaryaffiliation)
    end
  end

  def parse_staff_directory_values(directory_person)
    unless (directory_person.nil?)
      @staff_directory_id = directory_person[0]["empID"]
      @first_name = directory_person[0]["fname"]
      @last_name = directory_person[0]["lname"]
      @full_name = @first_name + ' ' + @last_name
      @position_title = directory_person[0]["jobTitle"]
    end
  end

  def identifier_context(identifier)
    valid_identifiers[identifier.to_sym]
  end

  def time_stamp
    DateTime.now.strftime('%m-%d-%Y %I:%M:%S%p')
  end

end
