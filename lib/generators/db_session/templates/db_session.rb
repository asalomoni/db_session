DbSession.setup do |config|
  config.session_validity = 60 * 60 * 24 * 2
end