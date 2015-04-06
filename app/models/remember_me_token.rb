class RememberMeToken < ActiveRecord::Base
  belongs_to :user

  def self.create_unique!
    value = loop do
      token = SecureRandom.urlsafe_base64
      break token unless exists?(value: token)
    end
    create! value: value
  end

  def expired?
    (created_at + 2.weeks) < Time.now
  end
end
