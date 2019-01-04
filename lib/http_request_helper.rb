require 'net/http'
require 'net/https'
require "addressable/uri"

module HttpRequestHelper

  def self.included(base)
    base.extend ClassMethods
  end


  class ResponseException < StandardError
    class Forbidden < ResponseException; end
    class InternalServerError < ResponseException; end
    class NotAuthorized < ResponseException; end
    class NotAcceptable < ResponseException; end
    class Redirect < ResponseException; end
    class ResourceNotFound < ResponseException; end
    class Unspecified < ResponseException; end
  end


  module ClassMethods

    def http_get(uri)
      uri = URIParser.call(uri)
      http = build_http(uri)

      return http_get_request(http, uri)
    end


    def build_uri(type, facade_obj)
      base_uri = Rails.configuration.api_backend_staff_directory
      case type
      when 'staff_directory_person'
        if (facade_obj.id == 'all')
          base_uri.sub(/\<\<type\>\>/, "employee").sub(/\/\<\<identifier\>\>/, '').sub(/\<\<id\>\>/, facade_obj.id.to_s)
        else
          base_uri.sub(/\<\<type\>\>/, "employee").sub(/\<\<identifier\>\>/, facade_obj.identifier).sub(/\<\<id\>\>/, facade_obj.id.to_s)
        end
      when 'staff_directory_org'
        base_uri.sub(/\<\<type\>\>/, "unit").sub(/\/\<\<identifier\>\>/, '').sub(/\<\<id\>\>/, facade_obj.id.to_s)
      when 'hours'
      end
    end


    private

    def build_http(uri)
      logger = Logger.new $stderr
      logger.level = Logger::ERROR
      Faraday.new(url: "#{uri.scheme}://#{uri.host}") do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger, logger
        faraday.adapter  Faraday.default_adapter
      end
    end


    def http_get_request(http, uri)
      response = http.get(uri.to_s)
      test_response(response, uri)

      response.body
    end


    def test_response(response, uri)
      case response.status.to_s
      when '200'
        return
      when '302'
        raise HttpRequestHelper::ResponseException::Redirect, '[ERROR] 302 Redirect found at ' + uri.to_s
      when '404'
        raise HttpRequestHelper::ResponseException::ResourceNotFound, '[ERROR] 404 Resource not found at ' + uri.to_s
      when '401'
        raise HttpRequestHelper::ResponseException::NotAuthorized, '[ERROR] 401 Not authorized at ' + uri.to_s
      when '403'
        raise HttpRequestHelper::ResponseException::Redirect, '[ERROR] 403 Forbidden at ' + uri.to_s
      when '406'
        raise HttpRequestHelper::ResponseException::NotAcceptable, '[ERROR] 406 Not Acceptable at ' + uri.to_s
      when '500'
        raise HttpRequestHelper::ResponseException::InternalServerError, '[ERROR] 500 Internal server error at ' + uri.to_s
      else
        raise HttpRequestHelper::ResponseException::Unspecified, '[ERROR] Unspecified error at ' + uri.to_s
      end
    end

  end

end
