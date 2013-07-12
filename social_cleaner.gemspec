# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'social_cleaner/version'


Gem::Specification.new do |spec|
  spec.name         = 'social_cleaner'
  spec.version      = SocialCleaner::VERSION
  spec.authors      = %w(Michaël Rigart)
  spec.email        = %w(michael@netronix.be)
  spec.summary      = 'Clean social media messages'
  spec.description  = 'Clean all messages from social media'
  spec.homepage     = 'http://www.michaelrigart.be/'
  spec.license      = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_dependency 'twitter', '>= 4.8'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end