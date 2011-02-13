# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "person_name/version"

Gem::Specification.new do |s|
  s.name              = "person-name"
  s.version           = PersonName::VERSION
  s.platform          = Gem::Platform::RUBY
  s.authors           = ["Matthijs Groen"]
  s.email             = ["matthijs.groen@gmail.com"]
  s.homepage          = %q{http://github.com/matthijsgroen/person-name}
  s.summary           = %q{Easy editing of person names.}
  s.description       = %q{Manages all person name fields (prefix, first name, middle name, intercalation, last name, suffix)}

  s.rubyforge_project = "person-name"

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths     = ["lib"]
end
