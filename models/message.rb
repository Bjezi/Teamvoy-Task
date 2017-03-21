class Message < ActiveRecord::Base
  validates :body, presence: true
  validates :password, presence: true
end
