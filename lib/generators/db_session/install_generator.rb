require 'rails/generators/base'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module DbSession
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def copy_db_session_migration
        migration_template 'create_db_session_stores.rb', 'db/migrate/create_db_session_stores.rb'
      end

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end
    end
  end
end

