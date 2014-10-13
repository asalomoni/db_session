$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "db_session/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "db_session"
  s.version     = DbSession::VERSION
  s.authors     = "Andrea Salomoni"
  s.email       = "andrea.salomoni@intersail.it"
  s.homepage    = "TODO"
  s.summary     = "Store temporary data on the database"
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.4"
  s.add_dependency "sidekiq"

  s.add_development_dependency "sqlite3"
end
