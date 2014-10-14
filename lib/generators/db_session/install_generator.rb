module DbSession
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)

      def copy_db_session_migration
        puts '>>>>>>>>>>>>>> ' if Rails::Generators::Migration.migration_exists?('db/migrate', 'create_db_session_stores.rb')
        migration_template 'create_db_session_stores.rb', 'db/migrate/create_db_session_stores.rb' unless Rails::Generators::Migration.migration_exists?('db/migrate', 'create_db_session_stores.rb')
      end

      def self.next_migration_number(dir)
        ActiveRecord::Generators::Migration.next_migration_number(dir)
      end
    end
  end
end


