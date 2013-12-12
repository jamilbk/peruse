Gem::Specification.new do |s|
  s.name                    = "plunk"
  s.version                 = "0.1.7"
  s.date                    = "2013-12-03"
  s.add_runtime_dependency  "json"
  s.add_runtime_dependency  "parslet"
  s.add_runtime_dependency  "rest-client"
  s.add_runtime_dependency  "activesupport"
  s.add_development_dependency "rspec"
  s.summary                 = "Elasticsearch query language"
  s.description             = "Human-friendly query language for Elasticsearch"
  s.authors                 = ["Ram Mehta", "Jamil Bou Kheir"]
  s.email                   = ["ram.mehta@gmail.com", "jamil@elbii.com"]
  s.files                   = `git ls-files`.split("\n")
  s.homepage                = "https://github.com/elbii/plunk"
  s.license                 = "MIT"
end
