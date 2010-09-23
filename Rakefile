require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "person_name"
    gem.summary = %Q{Easy editing of person names.}
    gem.description = %Q{
      Manages all person name fields (prefix, first name, middle name, intercalation, last name, suffix)
    }
    gem.email = "matthijs.groen@gmail.com"
    gem.homepage = "http://matthijsgroen.posterous.com"
    gem.authors = ["Matthijs Groen"]
    #gem.add_development_dependency "shoulda"
    gem.add_dependency "activerecord", "~> 3.0.0"
    gem.add_dependency "activesupport", "~> 3.0.0"
    gem.add_dependency "arel", "~> 1.0.1"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.libs << 'vendor/rails/activerecord/lib'
  test.libs << 'vendor/rails/activesupport/lib'
  test.libs << 'vendor/arel/lib'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

# Don't check dependencies since we're testing with vendored libraries
# task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "meta_where #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
