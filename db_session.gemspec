$:.push File.expand_path('../lib', __FILE__)

require 'db_session/version'

Gem::Specification.new do |s|
  s.name        = 'db_session'
  s.version     = DbSession::VERSION
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.authors     = ['Andrea Salomoni']
  s.email       = 'andrea.salomoni@intersail.it'
  s.homepage    = 'https://github.com/asalomoni/db_session'
  s.summary     = 'Simplify the task of storing temporary data in the database'
  s.description = 'Simplify the task of storing temporary data in the database'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails'
  s.add_dependency 'sidekiq'
  s.add_dependency 'colorize'

  s.add_development_dependency 'sqlite3'
end
