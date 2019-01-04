require 'uri'
module Discovery2
  module Holdings
    class GenerateMapURL
      attr_reader :holding

      def self.call(holding)
        new(holding).generate
      end

      def initialize(holding)
        @holding = holding
      end

      def generate
        if holding.library_code == "ANNEX" || holding.institution != "ndu"
          ""
        else
          "#{base_url}?xml=#{encoded_xml}"
        end
      end

      private

      def base_url
        if Rails.env == "production"
          "http://onesearch.library.nd.edu/primo_library/libweb/tiles/local/map.jsp"
        else
          "http://onesearchpprd.library.nd.edu//primo_library/libweb/tiles/local/map.jsp"
        end
      end

      def xml
        "<records><title>#{holding.title}</title><creator>#{holding.creator}</creator><record><call_number>#{holding.call_number}</call_number><sublibrary code=\"#{holding.library_code}\">#{holding.library}</sublibrary><collection code=\"#{holding.collection_code}\">#{holding.collection}</collection></record></records>"
      end

      def encoded_xml
        URI.encode(xml)
      end
    end
  end
end
