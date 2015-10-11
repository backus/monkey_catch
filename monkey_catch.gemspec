# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'monkey_catch/version'

Gem::Specification.new do |spec|
  spec.name          = 'monkey_catch'
  spec.version       = MonkeyCatch::VERSION
  spec.authors       = ['John Backus']
  spec.email         = ['johncbackus@gmail.com']

  spec.summary       = 'Catch monkey patching'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/backus/monkey_catch'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r(^bin/)) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'procto',     '~> 0.0.2'
  spec.add_runtime_dependency 'ice_nine',   '~> 0.11.1'
  spec.add_runtime_dependency 'adamantium', '~> 0.2.0'
  spec.add_runtime_dependency 'anima',      '~> 0.3.0'
  spec.add_runtime_dependency 'concord',    '~> 0.1.5'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10'
end
