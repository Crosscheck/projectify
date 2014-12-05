require 'colorize'
Gem::Specification.new do |s|
  s.name        = 'projectify'
  s.version     = '1.0.3'
  s.date        = '2014-12-05'
  s.summary     = 'Projectify your setup!'
  s.description = 'A small gem that creates a basic structure for a development project with drupal or capistrano in general.'
  s.authors     = ['Sebastiaan Provost']
  s.email       = 'seba@crosscheck.be'
  s.files       = ['lib/logging.rb', 'lib/projectify.rb']
  s.executables = ['projectify', 'gitify']
  s.homepage    =
    'http://github.com/CrossCheck/projectify'
  s.license       = 'MIT'
  s.add_dependency 'colorize'
  s.add_dependency 'json'
  s.add_dependency(%q<capistrano-didi>, [">= 0.4.5"])
end
