OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discogs, ENV['DISCOGS_KEY'], ENV['DISCOGS_SECRET']
end
