class Invite < ApplicationRecord
  include EmailNormalizable

  class Unavailable < StandardError; end

  LIFETIME = 7.days

  belongs_to :invited_by, class_name: "User", inverse_of: :invites

  enum :role, { admin: 0, exec: 1 }, validate: true

  normalizes_email :email
  validates :expires_at, presence: true
  validate :email_is_available, on: :create

  before_create :generate_token

  scope :pending, -> { where(accepted_at: nil).where("expires_at > ?", Time.current) }

  def expired?
    expires_at <= Time.current
  end

  def accepted?
    accepted_at.present?
  end

  def pending?
    !accepted? && !expired?
  end

  def accept!(password:, password_confirmation:)
    user = User.new(
      email_address: email,
      role: role,
      password: password,
      password_confirmation: password_confirmation
    )

    with_lock do
      raise Unavailable unless pending?

      user.save!
      update!(accepted_at: Time.current)
    end

    user
  end

  private

  def email_is_available
    if User.exists?(email_address: email)
      errors.add(:email, "already belongs to an account")
    elsif self.class.pending.exists?(email: email)
      errors.add(:email, "already has a pending invite")
    end
  end

  def generate_token
    self.token = loop do
      candidate = SecureRandom.urlsafe_base64(32)
      break candidate unless self.class.exists?(token: candidate)
    end
  end
end
