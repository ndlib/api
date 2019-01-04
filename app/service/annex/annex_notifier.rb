class AnnexNotifier

	attr_reader :outbound_dir, :inbound_dir, :archive_dir

	def initialize
		@outbound_dir = annex_configuration['aleph_outbound_dir']	
		@inbound_dir = annex_configuration['aleph_inbound_dir']	
		@archive_dir = annex_configuration['aleph_archive_dir']	
	end

	def append_to_send(barcode)
		send_file = open_file('send.barcodes', "a+")
		send_file.write("#{barcode}\n")		
		send_file.fsync
		send_file.close
	end

	def append_to_stock(barcode)
		stock_file = open_file('stock.barcodes', "a+")
		stock_file.write("#{barcode}\n")		
		stock_file.fsync
		stock_file.close
	end

	def archive_request(type, transaction_number)
		outbound_dir = open_dir("outbound")
		archive_dir = open_dir("archive")
		parsed_transaction_number = parse_transaction_number(transaction_number)
		converted_filename = convert_filename(type, parsed_transaction_number)
		file_to_move = File.open(outbound_dir.path + converted_filename, "r+")
		File.rename(file_to_move.path, archive_dir.path + converted_filename)
	end

	def reactivate_request(type, transaction_number)
		outbound_dir = open_dir("outbound")
		archive_dir = open_dir("archive")
		parsed_transaction_number = parse_transaction_number(transaction_number)
		converted_filename = convert_filename(type, parsed_transaction_number)
		file_to_move = File.open(archive_dir.path + converted_filename, "r+")
		File.rename(file_to_move.path, outbound_dir.path + converted_filename)
	end

	def remove_from_file(type, barcode)
		new_list = []
		if barcode_present?("#{type}", barcode)
			new_list = barcode_list("#{type}").map { |current_barcode| 
				current_barcode == barcode ? '' : "#{current_barcode}\n" }
		end
		file = open_file("#{type}.barcodes", "w")
		new_list.each { |barcode_record| file.write(barcode_record) }
		file.fsync
		file.close
	end

	def barcode_present?(type, barcode)
		result = false
		barcode_list(type).each do |list_barcode|
			list_barcode.match(/^#{barcode}$/) ? result = true : ''
		end
		result
	end

	private

	def annex_configuration
		if @annex_configuration.nil?
			path = File.join(Rails.root, 'config', 'annex.yml')
			@annex_configuration = YAML.load_file(path)[Rails.env]
		end
		@annex_configuration
	end

	def open_dir(dir)
		case dir
		when 'outbound'
			Dir.new(Rails.root + outbound_dir)
		when 'inbound'
			Dir.new(Rails.root + inbound_dir)
		when 'archive'
			Dir.new(Rails.root + archive_dir)
		end
	end

	def barcode_list(type)
		file = open_file("#{type}.barcodes", "a+")
		list = file.read.split("\n")
		file.close
		list
	end

	def open_file(filename, mode)
		dir = open_dir('inbound') 
		File.new(Rails.root + dir.path + "#{filename}", mode: "#{mode}")
	end

	def parse_transaction_number(transaction_number)
		transaction_number.match("_") ? transaction_number.split("_")[1] : transaction_number
	end

	def convert_filename(type, transaction_number)
		type + "." + transaction_number + ".json"
	end
end
