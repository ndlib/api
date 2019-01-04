class Resource::Datamart::Item < Resource::Datamart::Database

	self.table_name = 'itm'

	belongs_to :bib_record, class_name: "Datamart::BibRecord", foreign_key: "doc_nbr"

	def bib_id
		doc_nbr
	end

	def barcode
		brcde
	end

	def status_number
		itm_status_cde
	end

	def sequence_number
		itm_seq_nbr
	end

	def admin_document_number
		adm_doc_nbr
	end

	def call_number
		call_nbr
	end

	def bibliographic_isbn_issn
		bib_record.isbn_issn
	end

	def bibliographic_title
		bib_record.title	
	end

	def bibliographic_author
		bib_record.author
	end

	def bibliographic_imprint
		bib_record.imprint
	end

	def bibliographic_edition
		bib_record.edition
	end

	def description
		dsc
	end

	def internal_note
		note_intrnl
	end

	def condition
		parse_conditions
	end

	def sublibrary
		sublbry_nm
	end

	def self.by_barcode(item_barcode)
		Resource::Datamart::Item.where(brcde: item_barcode).first
	end

	private

	def parse_conditions
		if /^(.+)%/.match(internal_note)
			$1.split('|')
		end
	end
	
end