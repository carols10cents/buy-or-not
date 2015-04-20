OmniAuth.config.logger = Rails.logger
OmniAuth.config.full_host = lambda do |env|
  "http://#{env['HTTP_HOST']}"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discogs, ENV['DISCOGS_KEY'], ENV['DISCOGS_SECRET']
end

DISCOGS_CONSUMER = OAuth::Consumer.new(
  ENV['DISCOGS_KEY'],
  ENV['DISCOGS_SECRET'],
  {
    :site               => "https://api.discogs.com",
    :scheme             => :header,
    :http_method        => :post,
    :request_token_path => "/oauth/request_token",
    :access_token_path  => "/oauth/access_token"
  }
)
