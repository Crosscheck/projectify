require 'colorize'
Gem::Specification.new do |s|
  s.name        = 'projectify'
  s.version     = '1.6.0'
  s.date        = '2015-06-19'
  s.summary     = 'Projectify your setup!'
  s.description = 'A small gem that creates a basic structure for a development project with drupal or capistrano in general.'
  s.authors     = ['Sebastiaan Provost', 'Klaas Van Waesberghe']
  s.email       = 'support.gent@one-agency.be'
  s.files       = ['lib/logging.rb', 'lib/projectify.rb', 'lib/buildserver.rb']
  s.executables = ['projectify', 'gitify']
  s.homepage    ='http://github.com/CrossCheck/projectify'
  s.license       = 'MIT'
  s.add_dependency 'colorize'
  s.add_dependency 'json'
  s.add_dependency 'jenkins_api_client'
  s.add_dependency(%q<capistrano-didi>, [">= 0.4.14"])
end
