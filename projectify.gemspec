Gem::Specification.new do |s|
  s.name        = 'projectify'
  s.version     = '0.3.3'
  s.date        = '2014-08-28'
  s.summary     = "Projectify your setup!"
  s.description = "A small gem that creates a basic structure for a development project with drupal."
  s.authors     = ["Sebastiaan Provost"]
  s.email       = 'seba@crosscheck.be'
  s.files       = ["lib/projectify.rb"]
  s.executables << 'projectify'
  s.homepage    =
    'http://github.com/CrossCheck/projectify'
  s.license       = 'MIT'
  s.add_dependency 'colorize'
end
