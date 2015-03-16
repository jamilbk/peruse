# -*- encoding: utf-8 -*-
require File.expand_path('../lib/peruse/version', __FILE__)

Gem::Specification.new do |s|
  s.name                    = "peruse"
  s.version                 = Peruse::VERSION
  s.required_ruby_version   = ">= 1.9.3"
  s.add_runtime_dependency  "json", "~> 1.8", ">= 1.8.0"
  s.add_runtime_dependency  "parslet", "~> 1.5", ">= 1.5.0"
  s.add_runtime_dependency  "elasticsearch", "~> 1.0", ">= 1.0.0"
  s.add_runtime_dependency  "activesupport", "~> 4.0", ">= 4.0.0"
  s.add_runtime_dependency  "chronic", "~> 0.10", ">= 0.10.0"
  s.add_development_dependency "rspec", "~> 3.1", ">= 3.1.0"
  s.add_development_dependency "timecop", "~> 0.7", ">= 0.7.1"
  s.executables             << "peruse"
  s.summary                 = "Elasticsearch query language"
  s.description             = "Human-friendly query language for Elasticsearch. Formerly https://rubygems.org/gems/plunk."
  s.authors                 = ["Ram Mehta", "Jamil Bou Kheir"]
  s.email                   = ["ram.mehta@gmail.com", "jamil@elbii.com"]
  s.files                   = `git ls-files`.split("\n")
  s.homepage                = "https://github.com/elbii/peruse"
  s.license                 = "MIT"
end
