require "ipaddr"

class Admin::InternalLibraryServers

  SERVER_IP_RANGES = ["10.41.56.0/24", "10.41.57.0/24", "10.41.58.0/24", "10.41.59.0/24", "10.41.60.0/24", "10.41.61.0/24", "10.41.62.0/24"]

  def ip_address_is_internal?(test_ip)
    return true if rails_in_development?


    SERVER_IP_RANGES.each do | ip_range |
      return true if ip_address_is_in_range?(ip_range, test_ip)
    end

    return false
  end


  private

    def ip_address_is_in_range?(ip_range, test_ip)
      net = IPAddr.new(ip_range)
      (net===test_ip)
    end


    def rails_in_development?
      (Rails.env == 'development')
    end


end
