class User < ApplicationRecord
  has_secure_password

  enum :role, { admin: 0 }, validate: true

  normalizes :username, with: ->(username) { username.strip.downcase }

  validates :username, presence: true, uniqueness: true
end
