Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:8081/rails-openssl-monitor' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:8081/rails-openssl-monitor' }
end