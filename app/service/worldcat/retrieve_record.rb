module Worldcat
  # Retrieves record from the Worldcat API
  class RetrieveRecord
    include Virtus.model
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    attr_reader :id_type, :record_id, :base_url, :url_path, :rest_connection, :retrieved_record, :status_message

    validates :id_type, :record_id, presence: true

    def initialize(id_type, record_id)
      @id_type = id_type
      @record_id = record_id
      id_type && record_id ? set_base_url : nil
      set_url_path
      @rest_connection = ExternalRest.new(base_url: self.base_url, path: self.url_path, connection_opts: { response_format: 'json' })
    end

    def fetch_record
      begin
        @retrieved_record = self.rest_connection.transact
        @status_message = "Record found"
        determine_record_status
      rescue => e
        @status_message = "Error retrieving record: #{e.message}"
        @retrieved_record = :error_retrieving_record
      end
    end

    def to_json
      if status_message == 'Record found'
        record_metadata.to_json
      elsif status_message =~ /Error retrieving record/
        record_error
      else
        record_not_found
      end
    end

    private

    def set_base_url
      @base_url = Application::Secrets.worldcat_library_locations +
        self.id_type + '/' +
        self.record_id.to_s
    end

    def set_url_path
        @url_path = '?libtype=1&maximumLibraries=1&format=json&location=46556&wskey=' +
        Application::Secrets.worldcat_api_key
    end

    def determine_record_status
      if self.retrieved_record.diagnostic
        @status_message = retrieved_record.diagnostic.message
        @retrieved_record = :not_found
      end
    end

    def nd_owned?
      @retrieved_record.library[0].oclcSymbol == 'IND'
    end

    def opac_url
      @retrieved_record.library[0].opacUrl
    end

    def record_metadata
      { record:
        {
          title: @retrieved_record.title,
          author: @retrieved_record.author,
          publisher: @retrieved_record.publisher,
          nd_owned: nd_owned?,
          opac_url: opac_url
        }
      }
    end

    def record_not_found
      { record:
        {
        status: 'Record not found'
        }
      }.to_json
    end

    def record_error
      { record:
        {
        status: 'Error retrieving record - please see logs for details'
        }
      }.to_json
    end

  end
end
