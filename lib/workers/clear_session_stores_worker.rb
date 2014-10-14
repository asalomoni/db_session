require 'sidekiq'

class ClearSessionStoresWorker
  include Sidekiq::Worker
  def perform
    logger.error '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  end
end