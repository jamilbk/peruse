Gem::Specification.new do |s|
  s.name                    = "plunk"
  s.version                 = "0.3.6"
  s.add_runtime_dependency  "json", "~> 1.8", ">= 1.8.0"
  s.add_runtime_dependency  "parslet", "~> 1.5", ">= 1.5.0"
  s.add_runtime_dependency  "elasticsearch"
  s.add_runtime_dependency  "activesupport", "~> 4.0", ">= 4.0.0"
  s.add_runtime_dependency  "chronic", "~> 0.10", ">= 0.10.0"
  s.add_development_dependency "rspec", "~> 2.0", ">= 2.14.1"
  s.add_development_dependency "timecop", "~> 0.7", ">= 0.7.1"
  s.summary                 = "Elasticsearch query language"
  s.description             = "Human-friendly query language for Elasticsearch"
  s.authors                 = ["Ram Mehta", "Jamil Bou Kheir", "Roman Heinrich"]
  s.email                   = ["ram.mehta@gmail.com", "jamil@elbii.com", "roman.heinrich@gmail.com"]
  s.files                   = `git ls-files`.split("\n")
  s.homepage                = "https://github.com/elbii/plunk"
  s.license                 = "MIT"
end
