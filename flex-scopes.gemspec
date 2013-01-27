require 'date'

Gem::Specification.new do |s|
  s.name                      = 'flex-scopes'
  s.summary                   = 'ActiveRecord-like chainable scopes and finders for Flex'
  s.description               = <<-description
flex-scopes provides an easy to use ruby API to search ElasticSearch with ActiveRecord-like chainable and mergeables scopes.
  description
  s.homepage                  = 'http://github.com/ddnexus/flex-scopes'
  s.authors                   = ["Domizio Demichelis"]
  s.email                     = 'dd.nexus@gmail.com'
  s.extra_rdoc_files          = %w[README.md]
  s.files                     = `git ls-files -z`.split("\0")
  s.version                   = File.read(File.expand_path('../VERSION', __FILE__)).strip
  s.date                      = Date.today.to_s
  s.required_rubygems_version = ">= 1.3.6"
  s.rdoc_options              = %w[--charset=UTF-8]

  s.add_runtime_dependency 'flex', '~> 1.0.0'
end
