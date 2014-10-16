module DbSession
  require 'json'
  require 'colorize'
  require 'workers/clear_session_stores_worker'

  autoload :DbSessionStore, 'models/db_session_store'

  SESSION_KEY = :db_session_store_id

  mattr_accessor :session_validity

  def self.setup
    yield self
  end

  def get_from_db_session(key=nil)
    db_session_id = session[SESSION_KEY]
    db_session_id ? db_session = DbSessionStore.find_by(id: db_session_id) : db_session = nil

    if db_session
      main_data_object = JSON.parse(db_session.serialized_data)

      if key
        return rebuild_object(main_data_object[key.to_s])
      else
        main_data_object.each do |k, v|
          main_data_object[k] = rebuild_object(main_data_object[k])
        end
        return main_data_object
      end
    end
  end

  def set_db_session(key, object)
    clear_db_session

    can_be_stored = can_be_stored?(object)

    if can_be_stored
      main_data_object = {}
      main_data_object[key] = {class: get_class(object), object: object}

      db_session = DbSessionStore.create(serialized_data: main_data_object.to_json)

      session[SESSION_KEY] = db_session.id
    end

    clear_expired_sessions

    can_be_stored
  end

  def add_to_db_session(key, object)
    can_be_stored = can_be_stored?(object)

    if can_be_stored
      db_session_id = session[SESSION_KEY]
      db_session_id ? db_session = DbSessionStore.find_by(id: db_session_id) : db_session = nil

      db_session ? main_data_object = JSON.parse(db_session.serialized_data) : main_data_object = {}
      main_data_object[key] = {class: get_class(object), object: object}

      if db_session
        db_session.serialized_data = main_data_object.to_json
        db_session.save
      else
        db_session = DbSessionStore.create(serialized_data: main_data_object.to_json)
      end

      session[SESSION_KEY] = db_session.id
    end

    clear_expired_sessions

    can_be_stored
  end

  def clear_db_session
    db_session_id = session[SESSION_KEY]
    if db_session_id
      db_session = DbSessionStore.find_by(id: db_session_id)
      db_session.destroy if db_session
    end
  end

  private

  def rebuild_object(obj)
    if obj['class']
      new = class_from_string(obj['class']).new
      new.assign_attributes(obj['object'])
      new
    else
      obj['object']
    end
  end

  def get_class(obj)
    if obj
      if obj.class.ancestors.include?(ActiveRecord::Base) && obj.respond_to?(:assign_attributes)
        obj.class.name
      end
    end
  end

  def can_be_stored?(obj)
    begin
      JSON.parse(obj.to_json)
      return true
    rescue
      return false
    end
  end

  def class_from_string(str)
    str.split('::').inject(Object) do |mod, class_name|
      mod.const_get(class_name)
    end
  end

  def clear_expired_sessions
    begin
      ClearSessionStoresWorker.perform_async(session_validity)
    rescue Exception => e
      logger.error e.message.colorize(:color => :red, :background => :black)
      logger.error 'CONSEQUENCE: Old sessions are not been cleared from the database'.colorize(:color => :yellow, :background => :black)
    end
  end
end

ActionController::Base.send(:include, DbSession)

ActionController::Base.send(:helper_method, :get_from_db_session)
ActionController::Base.send(:helper_method, :set_db_session)
ActionController::Base.send(:helper_method, :add_to_db_session)
ActionController::Base.send(:helper_method, :clear_db_session)