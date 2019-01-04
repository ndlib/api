module Aleph
  # Service class for placing holds in Aleph
  class HoldRequest
    include Virtus.model
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_reader :rest_connection, :request_body, :request_status, :discovery_id

    attribute :patron_id, String
    attribute :record_id, String
    attribute :item_id, String
    attribute :pickup_location, String
    attribute :last_interest_date, String
    attribute :start_interest_date, String
    attribute :note, String
    attribute :rush_flag, Boolean
    attribute :request_body, String

    validates :patron_id, :item_id, :record_id,
              :request_body, :pickup_location, presence: true

    def initialize(discovery_id)
      @discovery_id = discovery_id
      @rest_connection = Aleph::REST.new
      parse_ids(discovery_id)
      set_defaults
    end

    def valid_request?
      create_request_body
      set_request_params
      valid_discovery_id?(discovery_id) && self.valid?
    end

    def place_hold_request
      create_request_body
      set_request_params
      if valid_request?
        @request_status = rest_connection.transact
      else
        validation_error_message
      end
    end

    private

    def set_defaults
      self.start_interest_date = Date.today.strftime('%Y%m%d')
      self.last_interest_date = Date.today.since(6.months).strftime('%Y%m%d')
    end

    def valid_discovery_id?(discovery_id)
      discovery_id =~ /(.+)\${3}(.+)\${3}(.+)/
      Regexp.last_match ? true : false
    end

    def validation_error_message
      if !valid_discovery_id?(discovery_id)
        'Invalid discovery id submitted'
      else
        errors.messages.keys[0].to_s + ' ' + errors.messages.values.first.first
      end
    end

    def create_request_body
      return unless request_body_params?
      self.request_body = "post_xml=<hold-request-parameters>
        <pickup-location>#{pickup_location}</pickup-location>
        <last-interest-date>#{last_interest_date}</last-interest-date>
        <start-interest-date>#{start_interest_date}</start-interest-date>
        <sub-author></sub-author><sub-title></sub-title>
        <pages></pages>
        <note-1>#{note}</note-1><note-2></note-2>
        <rush>#{rush_flag}</rush>
      </hold-request-parameters>"
    end

    def request_body_params?
      pickup_location &&  start_interest_date && last_interest_date
    end

    def set_request_params
      rest_connection.path = build_request_path
      rest_connection.verb = 'put'
      rest_connection.payload = request_body
    end

    def build_request_path
      "/rest-dlf/patron/#{patron_id}/record/#{record_id}/items/#{item_id}/hold"
    end

    def parse_ids(discovery_id)
      valid_discovery_id?(discovery_id) ? '' : return
      discovery_id =~ /(.+)\${3}(.+)\${3}(.+)/
      @patron_id = Regexp.last_match[1]
      @record_id = Regexp.last_match[2]
      @item_id = Regexp.last_match[3]
    end
  end
end
