class Invite < ApplicationRecord
  belongs_to :invited_by, class_name: "User"

  enum :role, { admin: 0, exec: 1 }

  before_create { self.token = SecureRandom.urlsafe_base64(32) }

  scope :pending, -> { where(accepted_at: nil).where("expires_at > ?", Time.current) }

  def expired?
    expires_at < Time.current
  end

  def accepted?
    accepted_at.present?
  end
end
