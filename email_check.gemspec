# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_check/version'

Gem::Specification.new do |spec|
  spec.name          = "email_check"
  spec.version       = EmailCheck::VERSION
  spec.authors       = ["Darshan Patil"]
  spec.email         = ["dapatil@gmail.com"]

  spec.summary       = %q{ActiveModel email validator. Checks MX records. Ships with lists of free, disposable email providers}
  spec.description   = %q{ActiveModel email validator. Checks MX records for domains. Allows you to block free/disposable email providers}
  spec.homepage      = "https://github.com/dapatil/email_check"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec","~> 3.2"
  spec.add_development_dependency "simplecov", "~> 0.10.0"
  spec.add_development_dependency "coveralls", "~> 0.8.1"
  spec.add_development_dependency "mail", "~> 2.5"
  spec.add_development_dependency "activemodel", "~> 4.2"
end
