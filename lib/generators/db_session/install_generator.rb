require 'rails/generators/migration'

module DbSession
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_db_session_migration
        migration_template 'create_db_session_stores.rb', 'db/migrate/create_db_session_stores.rb'
      end
    end
  end
end


