require 'secrets'

module LdapRequestHelper

  @@lc = nil

  def ldap_get(attr,value,type='standard')
    lc = ldap_connection(@@lc)
    lc.ldap_search(attr, value, type)
  end

  def ldap_connection(lc = LdapConnection.new)
    if lc.is_a?(LdapRequestHelper::LdapConnection)
      @@lc = lc
    else
      @@lc = LdapConnection.new
    end
  end

  private

  class LdapConnection

    def initialize
      build_ldap
    end

    def build_ldap args = {}
      [:host, :port, :encryption, :username, :password].each {|p| set_value(p, args) }
      @ldap_object = Net::LDAP.new(:connect_timeout => 15, :encryption => @ldap_encryption)
      @ldap_object.host = @ldap_host
      @ldap_object.port = @ldap_port
      raise Net::LDAP::LdapError, @ldap_object.get_operation_result if ldap_bind == false
      @ldap_object
    end

    def ldap_bind
      @ldap_object.auth(@ldap_username, @ldap_password)
      @ldap_object.bind(
        :method   => :simple,
        :username => @ldap_username,
        :password => @ldap_password
      )
    end

    def ldap_search(attr, value, type)
      filter = set_filter(type, attr, value)
      results = get_results(filter, type)
      unless (results.empty?)
        if (results.size >= 1)
          if (attr == 'sn')
            results
          elsif type == 'disjoined'
            results
          else
            results.first
          end
        end
      else
        return nil
      end
    end

    def get_results(filter,type)
      results = []
      param_list = {
        :base           => Rails.configuration.ldap_base,
        :filter         => filter,
        :return_result  => true
      }
      if type == 'disjoined'
        param_list[:attributes] = ['cn', 'givenName', 'sn', 'displayName']
        param_list[:size] = 10
      else
        param_list[:attributes] = ['givenName', 'displayName', 'cn', 'ndguid', 'sn', 'eduPersonPrimaryAffiliation', 'mail', 'postaladdress']
      end
      @ldap_object.search(param_list) do |entry|
        results.push(entry)
      end
      results
    end

    def set_filter(type, attr, value)
      if type == 'standard'
        Net::LDAP::Filter.equals(attr,value)
      elsif type == 'disjoined'
        full_filter(value)
      end
    end

    def full_filter(value)
      # modified_value = value # + '*'
      if value =~ /\s+/
        Net::LDAP::Filter.begins('cn',split_values(value).first) |
        Net::LDAP::Filter.begins('givenName',split_values(value).first) |
        Net::LDAP::Filter.ends('sn',split_values(value).last)
      else
        Net::LDAP::Filter.begins('cn',value) |
        Net::LDAP::Filter.begins('givenName',value) |
        Net::LDAP::Filter.ends('sn',value)
      end
    end

    def partial_filter(value)
      modified_value = value + '*'
      Net::LDAP::Filter.eq('displayName',modified_value)
    end

    def split_values(input)
      input.gsub(/\s+/m, ' ').strip.split(" ")
    end

    def set_value(type, args)
      case type
      when :host
        @ldap_host = args[:ldap_host] || Rails.configuration.ldap_host
        raise Net::LDAP::LdapError, "Missing host parameter" if @ldap_host.blank?
      when :port
        @ldap_port = args[:ldap_port] || Rails.configuration.ldap_port
        raise Net::LDAP::LdapError, "Missing port parameter" if @ldap_port.blank?
      when :encryption
        @ldap_encryption = args[:ldap_encryption] || :simple_tls
        raise Net::LDAP::LdapError, "Missing encryption parameter" if @ldap_encryption.blank?
      when :username
        @ldap_username = args[:ldap_username] || Application::Secrets.ldap_service_dn
        raise Net::LDAP::LdapError, "Missing username parameter" if @ldap_username.blank?
      when :password
        @ldap_password = args[:ldap_password] || Application::Secrets.ldap_service_password
        raise Net::LDAP::LdapError, "Missing password parameter" if @ldap_password.blank?
      end
    end

  end

end
