require 'active_record/connection_adapters/abstract_adapter'

module ActiveRecord
  module ConnectionAdapters
    class TableDefinition

      def person_name(name, *args)
        options = args.extract_options!
        name_parts = PersonName::NameSplitter::NAME_PARTS
        name_parts.each do |part|
          column("#{name}_#{part}".to_sym, :string, :null => true)
        end
      end

    end
  end
end
