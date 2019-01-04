class Resource::Datamart::BibRecord < Resource::Datamart::Database

	self.table_name = 'doc'

	has_many :items, :class_name => "Datamart::Item", :foreign_key => "doc_nbr"

	def title
		ttl_txt	
	end

	def author
		authr_nm
	end

	def imprint
		imprnt_txt
	end

	def edition
		edtn_txt	
	end

	def isbn_issn
		isbn_issn_txt
	end

end
