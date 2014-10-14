require 'rails/generators/active_record'

module DbSession
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      #include Rails::Generators::Migration
      #include ActiveRecord::Generators::Base

      source_root File.expand_path("../templates", __FILE__)

      def copy_db_session_migration
        migration_template 'create_db_session_stores.rb', 'db/migrate/create_db_session_stores.rb' unless migration_exists?('db/migrate/', 'create_db_session_stores.rb')
      end

=begin
      def self.next_migration_number(dir)
        Time.now.utc.strftime('%Y%m%d%H%M%S')
      end
=end
    end
  end
end


