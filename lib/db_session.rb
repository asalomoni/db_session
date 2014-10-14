module DbSession
  require 'json'
  require 'workers/clear_session_stores_worker'

  autoload :DbSessionStore, 'models/db_session_store'

  SESSION_KEY = :db_session_store_id

  mattr_accessor :session_validity

  def self.setup
    yield self
  end

  def validity_in_seconds(hours)
    hours * 3600
  end

  def get_from_db_session(key=nil)
    db_session_id = session[SESSION_KEY]
    db_session = DbSessionStore.find_by(id: db_session_id) if db_session_id

    if db_session
      main_data_object = JSON.parse(db_session.serialized_data)

      if key
        return main_data_object[key]
      else
        return main_data_object
      end
    end
  end

  def set_db_session(key, value)
    clear_db_session

    main_data_object = {}
    main_data_object[key] = value

    db_session = DbSessionStore.create(serialized_data: main_data_object.to_json)
    session[SESSION_KEY] = db_session.id

    clear_expired_sessions
  end

  def add_to_db_session(key, value)
    main_data_object = {}

    db_session_id = session[SESSION_KEY]
    db_session = DbSessionStore.find_by(id: db_session_id) if db_session_id

    main_data_object = JSON.parse(db_session.serialized_data) if db_session
    main_data_object[key] = value

    if db_session
      db_session.serialized_data = main_data_object.to_json
      db_session.save
    else
      db_session = DbSessionStore.create(serialized_data: main_data_object.to_json)
    end

    session[SESSION_KEY] = db_session.id

    clear_expired_sessions
  end

  def clear_db_session
    db_session_id = session[SESSION_KEY]
    if db_session_id
      db_session = DbSessionStore.find_by(id: db_session_id)
      db_session.destroy if db_session
    end
  end

  def clear_expired_sessions
    begin
      ClearSessionStoresWorker.perform_async(validity_in_seconds(session_validity))
    rescue Exception => e
      logger.error "\e[0;31m#{e.message}\e[0;31m\n\e[1;33m#{'CONSEQUENCE: Old sessions are not been cleared from the database'}\e[1;33m\e[0;39m"
    end
  end
end

ActionController::Base.send(:include, DbSession)