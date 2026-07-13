class User < ApplicationRecord
  include EmailNormalizable

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :invites,
    foreign_key: :invited_by_id,
    inverse_of: :invited_by,
    dependent: :restrict_with_error

  enum :role, { admin: 0, exec: 1 }, validate: true

  normalizes_email :email_address
  validates :email_address, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  def self.authenticate(email_address:, password:)
    authenticate_by(email_address: normalize_email(email_address), password: password)
  end
end
