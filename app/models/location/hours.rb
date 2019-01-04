class Location::Hours
  include HttpRequestHelper
  include CacheHelper

  attr_reader :codes, :date

  def initialize(codes, date)
    @codes = validate_codes(codes)
    @date = validate_date(date)
  end

  def retrieve_hours
    Rails.cache.fetch(cache_key, :expires_in => 1.hour) do
      self.class.http_get(uri)
    end
  end

  def cache_key
    "#{self.class.base_cache_key}/#{codes}-#{date}".gsub(/\s+/, "")
  end

  private

  def uri
    base_uri = Rails.configuration.api_backend_availability
    base_uri.sub(/\<\<codes\>\>/, "#{Rack::Utils.escape(codes)}").sub(/\<\<date\>\>/, "#{Rack::Utils.escape(date)}")
  end


  def validate_date(date)
    if date.is_a?(String)
      if date.empty?
        Date.today.to_s(:db)
      else
        date
      end
    elsif date.is_a?(Date)
      date.to_s(:db)
    else
      Date.today.to_s(:db)
    end
  end


  def validate_codes(codes)
    if !codes.is_a?(String)
      codes = codes.to_s
    end

    codes
  end

end
