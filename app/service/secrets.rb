require 'yaml'

class Application
  class Secrets
    def self.ldap_service_dn
      ldap["service_dn"]
    end

    def self.ldap_service_password
      ldap["service_password"]
    end

    def self.ldap_attrs
      ldap["attrs"]
    end

    def self.worldcat_api_key
      worldcat["api_key"]
    end

    def self.worldcat_library_locations
      worldcat["library_locations"]
    end

    def self.worldcat_bibliographic_info
      worldcat["bibliographic_info"]
    end

    def self.secret_key_base
      secrets["secret_key_base"]
    end

    def self.primo_link_oclc
      secrets["primo_link_oclc"]
    end

  private
    def self.secrets
      @@secrets ||= YAML.load_file('config/secrets.yml')[Rails.env]
    end

    def self.ldap
      @@ldap ||= secrets["ldap"]
    end

    def self.worldcat
      @@worldcat ||= secrets["worldcat"]
    end
  end
end
