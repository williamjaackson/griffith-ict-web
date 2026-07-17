class Invite < ApplicationRecord
  belongs_to :invited_by, class_name: "User"

  has_secure_token :token

  enum :role, { admin: 0, exec: 1 }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :pending, -> { where(accepted_at: nil).where("expires_at > ?", Time.current) }

  def accept!(password:, password_confirmation:)
    with_lock do
      ensure_pending!

      User.create!(
        email_address: email,
        role: role,
        password: password,
        password_confirmation: password_confirmation
      ).tap { update!(accepted_at: Time.current) }
    end
  end

  def expired? = expires_at.past?
  def accepted? = accepted_at.present?

  private

  def ensure_pending!
    return unless accepted? || expired?

    errors.add(:base, "Invite is no longer available")
    raise ActiveRecord::RecordInvalid, self
  end
end
