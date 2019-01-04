module Aleph
  # Representation of an Aleph item
  class Item
  	include Virtus.model
  	extend ActiveModel::Naming
  	include ActiveModel::Conversion
  	include ActiveModel::Validations
  	include RailsHelpers

  	attribute :process_status, String

  	def initialize(barcode)
  		@item = Resource::Datamart::Item.by_barcode(barcode)
  	end

  	def id
  		self.bib_id + self.sequence_number
  	end

  	def barcode
  		@item.barcode
  	end

  	def sequence_number
  		"%05d" % @item.sequence_number.to_i
  	end

  	def bib_id
  		"%09d" % @item.bib_id.to_i
  	end

  	def administrative_document_number
  		"%09d" % @item.admin_document_number.to_i
  	end

  	def exists?
  		!@item.blank?
  	end

  	def retrieve_record
  		exists? ? rest_connection('item_retrieve').transact.read_item.z30 : nil
  	end

  	def update_process_status(status)
  		if exists?
  			self.process_status = status
        parse_response(update_item_call)
  		else
  			nil
  		end
  	end

  	def to_json
  		{
  			item_id: self.id,
  			barcode: self.barcode,
  			bib_id: self.bib_id,
  			sequence_number: self.sequence_number,
  			admin_document_number: self.administrative_document_number,
  			call_number: @item.call_number,
  			description: @item.description,
  			title: @item.bibliographic_title,
  			author: @item.bibliographic_author,
  			publication: @item.bibliographic_imprint,
  			edition: @item.bibliographic_edition,
  			isbn_issn: @item.bibliographic_isbn_issn,
  			condition: @item.condition,
  			sublibrary: @item.sublibrary
  			}.to_json
  		end

  		private

  		def rest_configuration
  			if @rest_configuration.nil?
  				path = File.join(Rails.root, 'config', 'rest.yml')
  				@rest_configuration = YAML.load_file(path)[Rails.env]
  			end
  			@rest_configuration
  		end

  		def rest_connection(op)
  			ExternalRest.new(
  				base_url: rest_configuration['aleph_xservices_url'], 
  				path: url_path(op), 
  				connection_opts: { response_format: 'xml' })
  		end

  		def url_path(op)
  			case op
  			when 'item_retrieve'
  				rest_configuration['aleph_xservices_item_path'].sub(/\<\<barcode\>\>/, "#{Rack::Utils.escape(barcode)}")	
  			when 'item_update'
  			end
  		end

  		def request_body
  			body_prefix = 'op=update-item&library=NDU50&user_name=' + rest_configuration['aleph_xservices_username']
  			body_password = '&user_password=' + rest_configuration['aleph_xservices_password']
  			body_suffix = '&xml_full_req=' + process_status_xml
  			body_prefix + body_password + body_suffix
  		end

  		def process_status_xml
  			render_to_string('/aleph/item_update_process_status', { item: self }).chomp
  		end

      def update_item_call
        rest_connection = rest_connection('item_update')
        rest_connection.verb = 'post'
        rest_connection.payload = request_body
        rest_connection.transact.update_item
      end

      def parse_response(response)
        if response.error.is_a? Array || (!respons.error.include? "Item has been updated successfully")
          { status: "error", message: extract_error_response(response.error) }
        else
          { status: "ok", message: extract_error_response(response.error) }
        end
      end

      def extract_error_response(error_message)
        if error_message.is_a? Array
          error_message.join(" ")
        else
          error_message
        end 
      end
    end
  end
