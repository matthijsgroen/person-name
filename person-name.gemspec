# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{person-name}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthijs Groen"]
  s.date = %q{2010-09-24}
  s.description = %q{Manages all person name fields (prefix, first name, middle name, intercalation, last name, suffix)}
  s.email = %q{matthijs.groen@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "Gemfile",
     "Gemfile.lock",
     "MIT-LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/person-name.rb",
     "lib/person_name/has_person_name.rb",
     "lib/person_name/migration_support.rb",
     "lib/person_name/name.rb",
     "rails/init.rb",
     "spec/database.yml",
     "spec/database.yml.sample",
     "spec/models.rb",
     "spec/person_name/has_person_name_spec.rb",
     "spec/schema.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/matthijsgroen/person-name}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Easy editing of person names.}
  s.test_files = [
    "spec/person_name/has_person_name_spec.rb",
     "spec/spec_helper.rb",
     "spec/models.rb",
     "spec/schema.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

