class User < ActiveRecord::Base
  has_many :remember_me_tokens # So that you can be remembered on multiple devices.

  def self.from_omniauth(auth)
    user = where(provider: auth['provider'], uid: auth['uid']).first || create_from_omniauth(auth)
    user.token  = auth['credentials']['token']
    user.secret = auth['credentials']['secret']
    user.save!
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid      = auth['uid']
      user.username = auth['info']['username']
    end
  end

  def self.from_token(value)
    token = RememberMeToken.where(value: value).first
    if token
      if token.expired?
        token.destroy!
        return nil
      else
        token.user
      end
    end
  end

  def remember_me!
    token = RememberMeToken.create_unique!
    remember_me_tokens << token
    token
  end

  # i see you drivin round town with the girl i love and i'm like,
  def forget_me!(value)
    remember_me_tokens.where(value: value).destroy_all
  end

  def discogs
    @discogs ||= OAuth::AccessToken.from_hash(
      DISCOGS_CONSUMER,
      oauth_token: token,
      oauth_token_secret: secret
    )
  end

  def collection(page = 1)
    result = discogs.get(
      "https://api.discogs.com/users/#{username}/collection/folders/0/releases?page=#{page}",
      {"User-Agent" => "BuyOrNot"}
    )
    CollectionDecorator.new(result.body).essentials
  end
end
