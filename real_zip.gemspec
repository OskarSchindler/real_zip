# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'real_zip/version'
Gem::Specification.new do |spec|
  spec.name          = "real_zip"
  spec.version       = RealZip::VERSION
  spec.authors       = ["Prasad R."]
  spec.email         = ["thelaptopsage@gmail.com"]
  spec.description   = %q{ build zip files with given file structure for testing }.strip
  spec.summary       = %q{ build zip files with given file structure for testing }.strip
  spec.homepage      = "https://github.com/OskarSchindler/real_zip"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # deps:
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "rubyzip"  
  spec.add_runtime_dependency "zippy"  
end
