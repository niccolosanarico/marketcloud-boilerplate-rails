Marketcloud.configure do |config|
  config.public_key = ENV["marketcloud_public_key"]
  config.private_key = ENV["marketcloud_private_key"]
  config.set_up_cache(ENV["redis_url"], 3600)
  config.application = Application.find()
end
