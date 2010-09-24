require "active_record"

$LOAD_PATH.unshift(File.dirname(__FILE__))

require "person_name/name"
require "person_name/migration_support"
require "person_name/has_person_name"

$LOAD_PATH.shift

if defined?(ActiveRecord::ConnectionAdapters::TableDefinition)
  ActiveRecord::ConnectionAdapters::TableDefinition.send :include, PersonName::MigrationSupport
end
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, PersonName::ActiveRecord
end
