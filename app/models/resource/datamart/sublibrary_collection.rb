class Resource::Datamart::SublibraryCollection < Resource::Datamart::Database

	self.table_name = 'subl_coll'
	belongs_to :datamart_sublibrary, :foreign_key => "sublbry_nm", class_name: 'Resource::Datamart::Sublibrary'

	def sublibrary_code
		sublbry_nm
	end

	def collection_code
		coll_cde
	end

end
