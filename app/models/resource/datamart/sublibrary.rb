class Resource::Datamart::Sublibrary < Resource::Datamart::Database

	self.table_name = 'sublbry'

	def code
		sublbry_nm
	end

end
