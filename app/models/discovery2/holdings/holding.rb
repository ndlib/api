class Discovery2::Holdings::Holding
    attr_reader :record_id, :record_xml

    def initialize(record_id, record_xml)
      @record_id = record_id
      @record_xml = record_xml

      if !defined?(Empty)
        Struct.new("Empty", :content)
      end
    end

    def to_hash
      {
        record_id: record_id,
        institution: institution,
        library: library,
        library_code: library_code,
        collection: collection,
        collection_code: collection_code,
        call_number: call_number,
        available: available,
        available_on: available_on,
        status_message: status_message,
        non_circulating: non_circulating,
        notes: notes,
        holdings: holdings,
        supplements: supplements,
        indexes: indexes,
        detail_url: "http://alephprod.library.nd.edu/F?func=item-global&doc_library=#{base}&doc_number=#{doc_num}",
        map_url: Discovery2::Holdings::GenerateMapURL.call(self),
      }
    end

    def institution
      record_id.gsub(/_.*$/, "")
    end

    def title
      xpath('item/z13-title').first.content
    end

    def creator
      xpath('item/z13-author').first.content
    end

    def library
      xpath('item/z30-sub-library').first.content
    end

    def library_code
      xpath('datafield[@tag="852"]/subfield[@code="b"]').first.content
    end

    def collection
      xpath('item/z30-collection').first.content
    end

    def collection_code
      xpath('datafield[@tag="852"]/subfield[@code="c"]').first.content
    end

    def call_number
      "#{xpath('datafield[@tag="852"]/subfield[@code="h"]').first.content} #{xpath('datafield[@tag="852"]/subfield[@code="i"]').first.content}"
    end

    def available
      status = xpath('item/status').first.content
      @available ||= ProcessAvailable.new(status).available?
    end

    def available_on
      @available_on ||= xpath('item/status').first.content
    end

    def status_message
      raw_message = xpath('item/z30-item-status').first.content
      @status_message ||= ProcessedStatusMessage.new(raw_message).processed_message
    end

    def non_circulating
      status_code = xpath('item/z30-item-status-code').first.content
      sublibrary_code = xpath('item/z30-sub-library-code').first.content

      @non_circulating ||= ProcessNonCirculating.new(sublibrary_code, status_code).non_circulating?
    end

    def notes
      xpath("datafield[@tag='852']/subfield[@code='z']").collect { | node | node.content }
    end

    def holdings
      holdings_query('866')
    end

    def supplements
      holdings_query('867')
    end

    def indexes
      holdings_query('868')
    end

    private

    def xpath(path, context = false)
      if context
        searcher = context
      else
        searcher = record_xml
      end

      result = searcher.xpath(path)
      return result if result.present?

      [ Struct::Empty.new("") ]
    end


    def holdings_query(tag)
      ret = []
      xpath("datafield[@tag='#{tag}']").each do | subfield |
        if subfield.content.present?
          ret << "#{xpath("subfield[@code='a']", subfield).first.content} #{xpath("subfield[@code='z']", subfield).first.content}"
        end
      end

      ret
    end

    def doc_num
      @doc_num ||= record_id.scan(/([0-9]*)$/).first.first
    end

    def base
      case record_id.scan(/^([a-zA-Z]*)_aleph[0-9]*/).first.first
      when 'ndu'
        'NDU01'
      when 'hcc'
        'HCC01'
      when 'smc'
        'SMC01'
      when 'bci'
        'BCI01'
      end
    end

    class ProcessedStatusMessage
      attr_reader :original_message

      DIRECT_MATCHES = {
        "In Process LB" => "Labeling"
      }

      def initialize(original_message)
        @original_message = original_message
      end

      def processed_message
        strip_code
        return direct_match if direct_match
        substitute_match
      end

      private

      def direct_match
        if DIRECT_MATCHES[original_message]
          DIRECT_MATCHES[original_message]
        else
          false
        end
      end

      def substitute_match
        original_message.gsub(/\s[a-zA-Z]{2}$/, "")
      end

      def strip_code
        if original_message.present?
          original_message.gsub!(/^[0-9]{2}$/, '')
        end
      end
    end

    class ProcessNonCirculating
      attr_reader :sublibrary, :status_code

      def initialize(sublibrary, status_code)
        @sublibrary = sublibrary
        @status_code = status_code
      end

      def non_circulating?
        (always_non_circulating_sublibrary? ||
          always_non_circulating_status_code? ||
          non_circulating_execption?)
      end

      private

      def always_non_circulating_sublibrary?
        non_circulating_sublibraries.include?(sublibrary.upcase)
      end

      def always_non_circulating_status_code?
        non_circulating_status_codes.include?(status_code)
      end

      def non_circulating_execption?
        (execption_non_circulation_sublibraries_and_status_codes[sublibrary.upcase].present? &&
          execption_non_circulation_sublibraries_and_status_codes[sublibrary.upcase].include?(status_code))
      end

      def non_circulating_sublibraries
        ['REF', 'SPEC', 'MICRO', 'MEDIN', 'RARE', 'MRARE']
      end

      def non_circulating_status_codes
        ['95','98','05','07','15','97','43','56','65']
      end

      def execption_non_circulation_sublibraries_and_status_codes
        { 'MATH' => ['02','03'], 'ARCHT' => ['02','03'] }
      end
    end

    class ProcessAvailable
      attr_reader :status

      def initialize(status)
        @status = status
      end

      def available?
        return false if status.present?
        true
      end
    end
end
