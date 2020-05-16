Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis/rails-openssl-monitor' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis/rails-openssl-monitor' }
end