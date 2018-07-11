# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'k8s/templates/compiler/version'

Gem::Specification.new do |spec|
  spec.name          = 'k8s-templates-compiler'
  spec.version       = K8s::Templates::Compiler::VERSION
  spec.authors       = ['Mateusz Koszutowski']
  spec.email         = ['mkoszutowski@divante.pl']

  spec.summary       = 'Compiler for ERB template for Kubernetes manifests'
  spec.description   = 'Compiler for ERB template for Kubernetes manifests'
  spec.homepage      = 'https://github.com/DivanteLtd/k8s-templates-compiler'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.48'
end
