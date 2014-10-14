class DbSessionStore < ActiveRecord::Base
=begin
  def self.clear_expired_sessions
    DbSessionStore.all.each do |store|
      store.destroy if Time.now > store.updated_at + DbSession::SESSION_VALIDITY.seconds
    end
  end
=end
end
