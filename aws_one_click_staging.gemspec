# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_one_click_staging/version'

Gem::Specification.new do |spec|
  spec.name          = "aws_one_click_staging"
  spec.version       = AwsOneClickStaging::VERSION
  spec.authors       = ["TheNotary"]
  spec.email         = ["no@email.plz"]

  spec.summary       = %q{ When setup with the proper credentials, this gem sets up a staging instance of all the crap you have on amazon. }
  spec.homepage      = "https://github.com/TheNotary/aws_one_click_staging"
  # spec.license       = "MIT" # uncomment this line if MIT is the best license for your situation

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency "aws-sdk-v1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
