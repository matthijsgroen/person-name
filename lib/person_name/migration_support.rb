
module PersonName::MigrationSupport

	def person_name(name, *args)
		options = args.extract_options!
		name_parts = PersonName::Name::NAME_PARTS
		name_parts.each do |part|
			column("#{name}_#{part}".to_sym, :string, :null => true)
		end
	end

end
