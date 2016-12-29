Marketcloud.configure do |config|
  config.public_key = ENV["marketcloud_public_key"]
  config.private_key = ENV["marketcloud_private_key"]
end
