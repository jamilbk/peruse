Gem::Specification.new do |s|
  s.name                    = "plunk"
  s.version                 = "0.0.0"
  s.date                    = "2013-11-26"
  s.add_runtime_dependency  "json"
  s.add_runtime_dependency  "parslet"
  s.add_runtime_dependency  "rest-client"
  s.add_development_dependency "rspec"
  s.summary                 = "Elasticsearch query language"
  s.description             = "Human-friendly query language for Elasticsearch"
  s.authors                 = ["Ram Mehta", "Jamil Bou Kheir"]
  s.email                   = ["jamil@elbii.com", "ram.mehta@gmail.com"]
  s.files                   = `git ls-files`.split("\n")
  s.homepage                = "https://github.com/elbii/plunk"
  s.license                 = "MIT"
end
