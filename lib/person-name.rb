require "active_record"

$LOAD_PATH.unshift(File.dirname(__FILE__))

require "person_name/name_splitter"
require "person_name/name"
require "person_name/has_person_name"
require "person_name/migration_support"

$LOAD_PATH.shift

if defined?(ActiveRecord::ConnectionAdapters::SchemaStatements)
  ActiveRecord::ConnectionAdapters::SchemaStatements.send :include, PersonName::MigrationSupport
end
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, PersonName::ActiveRecord
end
