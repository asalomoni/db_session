require 'sidekiq'
require 'models/db_session_store'

class ClearSessionStoresWorker
  include Sidekiq::Worker
  def perform(session_validity)
    DbSessionStore.all.each do |store|
      store.destroy if Time.now > store.updated_at + session_validity.seconds
    end
  end
end