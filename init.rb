require 'person_name'
require 'person_name/migration_support'

ActiveRecord::ConnectionAdapters::TableDefinition.send :include, PersonName::MigrationSupport
ActiveRecord::Base.send :include, PersonName::ActiveRecord
