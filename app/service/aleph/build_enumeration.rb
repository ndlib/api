module Aleph
  class BuildEnumeration
    def self.call(item)
      new(item).parse
    end

    def initialize(item)
      @item = item
    end

    # rubocop:disable Metrics/AbcSize
    def parse
      enumeration_string = ""
      ("a"..."h").each do |e|
        field_name = "z30_enumeration_#{e}"
        @item.z30.send(field_name) ? (enumeration_string += " " + @item.z30.send(field_name)) : enumeration_string
      end
      ("i"..."m").each do |c|
        field_name = "z30_chronological_#{c}"
        @item.z30.send(field_name) ? (enumeration_string += " " + @item.z30.send(field_name)) : enumeration_string
      end
      enumeration_string[0] = ""
      enumeration_string.blank? ? "1" : enumeration_string
    end
  end
end
