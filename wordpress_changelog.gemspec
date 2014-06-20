# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wordpress_changelog/version'

Gem::Specification.new do |spec|
  spec.name          = "wordpress_changelog"
  spec.version       = WordpressChangelog::VERSION
  spec.authors       = ["Gabriel Bretschner"]
  spec.email         = ["software@kanedo.net"]
  spec.summary       = "Tool to generate a merged changelog of wordpress versions"
  spec.description   = "Scrapes the Wordpress Codex and merges all changes in to one clear document"
  spec.homepage      = "https://blog.kanedo.net"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["wordpress_changelog"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency "nokogiri", "~>1.6"
  spec.add_runtime_dependency 'terminal-table', "~>1.4"
end
