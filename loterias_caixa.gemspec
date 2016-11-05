# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loterias_caixa/version'

Gem::Specification.new do |spec|
  spec.name          = "loterias_caixa"
  spec.version       = LoteriasCaixa::VERSION
  spec.authors       = ["gioknx"]
  spec.email         = ["giovanikx@gmail.com"]

  spec.summary       = %q{Busca dados sobre as loterias da Caixa Federal}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/gioknx/loterias_caixa"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "coveralls"


 spec.add_runtime_dependency "nokogiri"
 spec.add_runtime_dependency "rest-client"
 spec.add_runtime_dependency "minitest-reporters"
 spec.add_runtime_dependency "coveralls"
 spec.add_runtime_dependency "simplecov"
 spec.add_runtime_dependency "codeclimate-test-reporter", "~> 1.0.0"



end
