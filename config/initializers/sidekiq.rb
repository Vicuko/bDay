Sidekiq.configure_server do |config|
  config.redis = { url: ENV['sidekiq_server'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['sidekiq_client'] }
end