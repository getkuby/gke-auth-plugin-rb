$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'gke-auth-plugin-rb/version'

Gem::Specification.new do |s|
  s.name     = 'gke-auth-plugin-rb'
  s.version  = ::GKEAuthPluginRb::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/getkuby/gke-auth-plugin-rb'
  s.license  = 'MIT'

  s.summary = 'The gke-auth-plugin executable by @traviswt distributed as a Rubygem.'
  s.description = 'The gke-auth-plugin executable by @traviswt distributed as a Rubygem.'

  s.platform = Gem::Platform::RUBY

  s.require_path = 'lib'
  s.files = Dir['{lib,spec,vendor}/**/*', 'Gemfile', 'LICENSE', 'CHANGELOG.md', 'README.md', 'Rakefile', 'gke-auth-plugin-rb.gemspec']
end
