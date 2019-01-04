module Aleph
  # Representation of an Aleph hold item
  class HoldList
    include Virtus.model
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    validates_with ::HoldListValidator

    attribute :system_id_list, Array
    attribute :patron_id, String
    attribute :raw_item_list, Hash
    attribute :unique_items, Array
    attribute :cache_key, String

    validates :system_id_list, :patron_id, presence: true, strict: true

    def initialize(system_ids = [], p_id)
      self.patron_id = p_id
      self.system_id_list = system_ids
      self.cache_key = generate_key
      self.raw_item_list = {}
    end

    def populate_raw_item_list
      raw_lists = retrieve_item_lists_threaded
      raw_lists.each do |raw_sys_id, raw_list|
        if available_for_hold?(raw_list)
          hold_list = build_hold_items(raw_list.hold.institution.group)
          build_institutional_list(raw_sys_id, hold_list)
        end
      end
    end

    def retrieve_item_lists_threaded
      # Referencing these classes to prevent them from loading during the threading
      Aleph::REST
      Aleph::REST::Connection
      raw_lists = []
      threaded_each(system_id_list, 5) do |sys_id|
        raw_lists << [sys_id, request_list(sys_id)]
      end
      raw_lists
    end

    def request_list(sys_id)
      rest_api = Aleph::REST.new
      rest_api.path = build_request_path(*parse_id(sys_id))
      raw_list = retrieve_list(rest_api)
    end

    def unique_items
      @unique_items ||= filter_unique_items
    end

    def unsorted_volumes
      unique_items.collect{|unique_item| unique_item[1]}
    end

    def volumes
      @volumes ||= unsorted_volumes.sort{|a,b| a[:sort_order].to_i <=> b[:sort_order].to_i}
    end

    private

    def generate_key
      patron_id + '-' + system_id_list.join('-')
    end

    def rest_api
      @rest_api ||= Aleph::REST.new
    end

    def parse_id(raw_sys_id)
      raw_sys_id =~ /(\w{3})_aleph(\d+)/
      [Regexp.last_match[1], Regexp.last_match[2]]
    end

    def build_request_path(institution_id, system_id)
      raw_uri = "rest-dlf/patron/#{patron_id}/record/###INST######ID###/holds"
      raw_uri.sub!(/###INST###/, institution_id.upcase + '01')
      raw_uri.sub(/###ID###/, format('%09d', system_id.to_i))
    end

    def retrieve_list(api_to_use = nil)
      api_to_use ||= rest_api
      api_to_use.transact.hold_grp_list
    end

    def build_hold_items(raw_hold_list)
      if !raw_hold_list.is_a?(Array)
        raw_hold_list = [raw_hold_list]
      end
      build_hold_items_threaded(raw_hold_list)
    end

    def build_hold_items_threaded(raw_hold_list)
      require 'thread'
      items = []
      # Referencing the hold item class prevents it from loading via a thread
      hold_item_class = Aleph::HoldItem
      # Retrieving items is much faster when threading requests to ALEPH
      # 8 threads is the limit where making more requests no longer improves performance
      threaded_each(raw_hold_list, 8) do |item|
        retrieved_item = retrieve_item(item)
        items << hold_item_class.new(retrieved_item) unless retrieved_item.item_serv.item.info[0].allowed == 'N'
      end
      items
    end

    def threaded_each(collection, number_of_threads = 5)
      queue = Queue.new
      collection.each {|item| queue << item}
      process_threaded(number_of_threads) do
        while (item = queue.pop(true) rescue nil)
          if item.present?
            yield item
          end
        end
      end
    end

    def process_threaded(number_of_threads = 5)
      threads = []
      number_of_threads.times do
        threads << Thread.new do
          yield
        end
      end
      wait_for_threads_to_complete(threads)
    end

    def wait_for_threads_to_complete(threads)
      # Thread#join will not return until the thread is done executing its block
      threads.each {|t| t.join }
    end

    def build_institutional_list(raw_sys_id, hold_list)
      current_key = parse_id(raw_sys_id)[0].to_sym
      if raw_item_list.key?(current_key)
        current_hold_list = raw_item_list[current_key]
        combined_hold_list = current_hold_list.concat(hold_list)
        raw_item_list[current_key] = combined_hold_list
      else
        raw_item_list[parse_id(raw_sys_id)[0].to_sym] = hold_list
      end
    end

    def filter_unique_items
      merged_list = {}
      raw_item_list.each_key do |inst_code|
        raw_item_list[inst_code].each do |item|
          item_enumeration = item.enumeration || 'single_volume'
          merged_list[item_enumeration] = unique_item_hash(item)
        end
      end
      merged_list
    end

    def unique_item_hash(item)
      {
        description: item.item_description || 'single_volume',
        enumeration: item.enumeration || '1',
        sort_order: item.enumeration || '1'
      }
    end

    def retrieve_item(item)
      rest_api = Aleph::REST.new
      rest_api.path = item.href.sub!(/holds/, 'items')
      rest_api.transact
    end

    def available_for_hold?(hold_list)
      if hold_list.hold.allowed == 'Y'
        true
      else
        false
      end
    end
  end
end
