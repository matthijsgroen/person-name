
module PersonName::MigrationSupport

  def person_name(name, *args)
    self.add_name_columns(self, name, *args)
  end

  def self.add_name_columns(table, prefix, *args)
    options = args.extract_options!
    name_parts = PersonName::NameSplitter::NAME_PARTS
    name_parts.each do |part|
      table.column("#{prefix}_#{part}".to_sym, :string, :null => true)
    end
  end

end
