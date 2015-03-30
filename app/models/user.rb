class User < ActiveRecord::Base
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
end
