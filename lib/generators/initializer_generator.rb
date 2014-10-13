class InitializerGenerator < Rails::Generators::Base
  def initialize_db_session
    copy_file 'db_session/db_session_store.rb', 'app/models/db_session_store.rb'
    copy_file 'db_session/create_db_session_stores.rb', "db/migrate/#{Time.now.strftime('%Y%m%d%H%M%S')}_create_db_session_stores.rb"
  end
end