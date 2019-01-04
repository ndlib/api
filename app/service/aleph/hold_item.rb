module Aleph
  # Representation of an Aleph hold item
  class HoldItem
    include Virtus.model
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_reader :item, :full_response

    attribute :bib_id, String
    attribute :item_number, String
    attribute :item_description, String
    attribute :enumeration, String
    attribute :holding_library, String
    attribute :sublibrary, String
    attribute :location, String
    attribute :collection, String
    attribute :hold_request_uri, String

    validates :bib_id, :item_number, :holding_library, presence: true

    def initialize(item_object)
      @full_response = item_object.item_serv
      @item = item_object.item_serv.item
      parse_item_object(item_object)
    end

    def pickup_locations
      location_array = @item.info[0]
        .hold.pickup_locations.pickup_location
      location_array.map do |l|
        location = Hash.new
        location[:code] = l.code
        location[:content] = l.__content__
        location
      end
    end

    private

    # rubocop:disable Metrics/AbcSize
    def parse_item_object(item_object)
      return unless item_object.item_serv.respond_to?(:item)
      self.item_description = @item.z30.z30_description
      self.item_number = build_item_number
      self.enumeration = Aleph::BuildEnumeration.call(@item)
      self.location = @item.z30.z30_call_no
      self.collection = @item.z30.z30_collection
      self.bib_id = @item.z30.z30_doc_number
      self.hold_request_uri = @item.info[0].href
      self.sublibrary = @item.z30_sub_library_code
      self.holding_library = @item.z30.translate_change_active_library
    end

    def build_item_number
      item_number = nil
      @item.info.each do |info|
        next unless info.type == 'HoldRequest'
        item_number = parse_request_uri(info.href)
      end
      item_number
    end

    def parse_request_uri(uri)
      match = %r{rest-dlf/patron/(.+)/record/(.+)/items/(.+)/hold}.match(uri)
      match[1] + '$$$' + match[2] + '$$$' + match[3]
    end
  end
end
