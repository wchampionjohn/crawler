redis_ns = "#{Settings.sidekiq.redis_ns_prefix}#{Rails.env}"
Sidekiq.configure_server do |config|
   config.redis = {
     namespace: redis_ns
   }
end
Sidekiq.configure_client do |config|
   config.redis = {
     namespace: redis_ns
   }
end
