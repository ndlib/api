class Discovery2::HoldRequest
  include CacheHelper

  attr_reader :id, :patron_id, :record_request

  def initialize(id, patron_id, record_request = nil)
    @id = id
    @patron_id = patron_id
    if record_request.blank?
      @record_request = request_record(id)
    else
      @record_request = record_request
    end
  end

  def record
    record_request.record
  end

  def hold_record_ids
    record_request.record_identifiers.map { |id|
      parse_id_number(id)
    }.compact
  end

  def hold_list
    @hold_list ||= build_hold_list
  end

  def build_hold_list
    Aleph::HoldList.new(hold_record_ids, patron_id).tap do |list|
      list.populate_raw_item_list
    end
  end

  def volumes
    hold_list.volumes
  end

  def enumerated_items
    items_by_enumeration = {}
    hold_list.raw_item_list.keys.each do |institution_code|
      hold_list.raw_item_list[institution_code].each do |hold_item|
        current_enumeration = Aleph::BuildEnumeration.call(hold_item.item)
        items_by_enumeration[current_enumeration] = [] unless items_by_enumeration[current_enumeration].kind_of?(Array)
        items_by_enumeration[current_enumeration].push(hold_item)
      end
    end
    items_by_enumeration
  end

  def combined_list
    {}.tap do |holds_list|
      holds_list[:holds_list] = {
        volumes: volumes,
        items_by_enumeration: get_enumerated_items
      }
    end
  end

  private

  def get_enumerated_items
    [].tap do |volume_group|
      enumerated_items.keys.sort.each do |volume_enumeration|
        volume_group_hash = {
          enumeration: volume_enumeration,
          items: [].tap do |current_items|
            enumerated_items[volume_enumeration].each do |current_item|
              current_items.push(item_to_hash(current_item))
            end
          end
        }
        volume_group.push(volume_group_hash)
      end
    end
  end

  def item_to_hash(current_item)
    {
      institution_code: current_item.holding_library,
      pickup_locations: current_item.pickup_locations,
      description:      current_item.item_description,
      bib_id:           current_item.bib_id,
      item_id:          current_item.item_number,
      status_message:   current_item.item.status ? current_item.item.status : '',
      location:         current_item.location
    }
  end

  def request_record(id)
    Discovery2::RecordRequest.new(id)
  end

  def parse_id_number(id)
    id =~ /\w+_aleph(\d+)/
    if Regexp.last_match
      id
    end
  end

end
