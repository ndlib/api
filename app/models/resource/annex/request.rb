class Resource::Annex::Request
	attr_reader :attributes
	private :attributes

	def initialize(json_record)
		@attributes = json_record.clone
		encode_attributes!
	end

	def formatted_description
		description = ""

		# Desc of field_formats structure:
		# fields is a list of field names to pass to sprintf
		# format is the sprintf format for the fields
		# add_when is expected to either be boolean, or a lambda that returns a boolean,
		#   if true it will append the formatted fields to the description string

		# Aleph requests will give a description that is already formatted in a similar fashion.
		# So if we are given a description, we'll just use it, otherwise we need to generate it.
		if field_present("description")
			field_formats = [
				{ fields: ["description"], format: " %s", add_when: true },
				{ fields: ["pages"], format: " p.", add_when: add_pages_prefix? },
				{ fields: ["pages"], format: " %s", add_when: field_present("pages")},
			]
		else
			field_formats = [
				{ fields: ["volume"], format: " %s", add_when: field_present("volume") },
				{ fields: ["issue"], format: ":", add_when: field_present("issue") && field_present("volume") },
				{ fields: ["issue"], format: " %s", add_when: field_present("issue") },
				{ fields: ["month"], format: " (%s)", add_when: field_present("month") && !field_present("year") },
				{ fields: ["year"], format: " (%s)", add_when: field_present("year") && !field_present("month") },
				{ fields: ["year", "month"], format: " (%s-%s)", add_when: field_present("year") && field_present("month") },
				{ fields: ["pages"], format: " p.", add_when: add_pages_prefix? },
				{ fields: ["pages"], format: " %s", add_when: field_present("pages")},
				{ fields: [], format: ";", add_when: lambda { field_present("pieces") && description != "" } },
				{ fields: ["pieces"], format: " pieces: %s", add_when: field_present("pieces") }
			]
		end

		field_formats.each do |f|
			add_when = f[:add_when]
			add_it = add_when.is_a?(Proc) ? add_when.call : add_when
			if add_it
				description += format_field(f[:fields], f[:format])
			end
		end
		description.strip
	end

	# Returns true if there is a value for pages that does not already contain a 'p' prefix
	def add_pages_prefix?
		field_present("pages") &&
		(pages =~ /^\s*(p|P)(\.)?\s*/).nil?
	end

	# Takes a list of fields and a sprintf format and returns the formatted string with the values from those fields
	# Note: Assumes that each field exists
	def format_field(fields, format)
		interp_params = []
		fields.each do |field|
			interp_params.push(fetch(field))
		end
		sprintf(format, *interp_params)
	end

	def field_present(field_name)
		fetch(field_name).present?
	end

	def isbn_issn
		if fetch(:isbn).present?
			fetch(:isbn)
		else
			fetch(:issn)
		end
	end

	def journal_title
		fetch(:jtitle)
	end

	def call_number
		fetch(:call_number)
	end

	def system_id
		fetch(:SystemID)
	end

	def bib_number
		if fetch(:bib_number).present?
			fetch(:bib_number).rjust(9, "0")
		else
			""
		end
	end

	def adm_number
		if fetch(:adm_number).present?
			fetch(:adm_number).rjust(9, "0")
		else
			""
		end
	end

	def transaction_number
		if fetch(:transaction).present? && fetch(:source).present?
			fetch(:source).gsub(/\s/, "-").downcase + "-" + fetch(:transaction)
		else
			""
		end
	end

	def item_sequence
		if fetch(:item_sequence).present?
			fetch(:item_sequence).gsub('.', '').lstrip.rjust(5, "0")
		else
			""
		end
	end

	def request_date
		if fetch(:request_date).present?
			DateTime.parse(fetch(:request_date)).to_time
		else
			""
		end
	end

	def as_json
		formatted
	end

	def to_json
		formatted.to_json
	end

	def article_title
		fetch(:article_title)
	end

	def article_author
		fetch(:article_author)
	end

	def author
		fetch(:author)
	end

	def barcode
		fetch(:barcode)
	end

	def delivery_type
		fetch(:delivery_type)
	end

	def patron_status
		fetch(:user_status)
	end

	def patron_department
		fetch(:department)
	end

	def patron_institution
		fetch(:institution)
	end

	def pickup_location
		fetch(:pickup)
	end

	def request_type
		fetch(:request_type)
	end

	def pages
		fetch(:pages)
	end

	def rush
		fetch(:rush)
	end

	def send_to
		fetch(:send_to)
	end

	def source
		fetch(:source)
	end

	def title
		fetch(:title)
	end

	def formatted
		{
			transaction: transaction_number,
			request_date_time: request_date,
			request_type: request_type,
			delivery_type: delivery_type,
			source: source,
			title: title,
			author: author,
			description: formatted_description,
			pages: pages,
			journal_title: journal_title,
			article_title: article_title,
			article_author: article_author,
			barcode: barcode,
			isbn_issn: isbn_issn,
			bib_number: bib_number,
			adm_number: adm_number,
			ill_system_id: system_id,
			item_sequence: item_sequence,
			call_number: call_number,
			send_to: send_to,
			rush: rush,
			patron_status: patron_status,
			patron_department: patron_department,
			patron_institution: patron_institution,
			pickup_location: pickup_location,
		}
	end

	private

	def fetch(name)
		attributes.fetch(name.to_s, nil) || ""
	end

	def encode_attributes!
		attributes.each do |_key, value|
			if value.is_a?(String)
				# Remove any invalid character encodings.
				# http://stackoverflow.com/questions/11375342/stringencode-not-fixing-invalid-byte-sequence-in-utf-8-error
				value.encode!("UTF-16", invalid: :replace, undef: :replace)
				value.encode!("UTF-8")
			end
		end
	end
end
