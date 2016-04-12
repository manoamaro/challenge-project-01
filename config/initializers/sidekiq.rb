Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/12' }
  config.average_scheduled_poll_interval = 1
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/12' }
end
