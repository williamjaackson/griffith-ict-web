class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :invites, foreign_key: :invited_by_id, inverse_of: :invited_by, dependent: :restrict_with_error

  enum :role, { admin: 0, exec: 1 }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
