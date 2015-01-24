# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'perfinator/version'

Gem::Specification.new do |spec|
  spec.name          = "perfinator"
  spec.version       = Perfinator::VERSION
  spec.authors       = ["Daniel Dreier"]
  spec.email         = ["d@puppetlabs.com"]
  spec.summary       = %q{Send detailed HTTP benchmark results to statsd}
  spec.description   = %q{HTTP load testing and benchmarking tool with statsd output}
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_dependency('methadone', '~> 1.8.0')
  spec.add_dependency('curb', '~> 0.8.6')
  spec.add_dependency('statsd-ruby', '~> 1.2.1')
  spec.add_dependency('parallel', '~> 1.3.3')
  spec.add_dependency('chronic_duration', '~> 0.10.6')
end
