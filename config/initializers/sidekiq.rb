Sidekiq.configure_server do |config|
	  config.redis = { url: ENV["REDISTOGO_URL"] || "redis://redis.local/2" }
end

Sidekiq.configure_client do |config|
	  config.redis = { url: ENV["REDISTOGO_URL"] || "redis://redis.local/2" }
end
