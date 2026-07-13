class Session < ApplicationRecord
  LIFETIME = 30.days

  belongs_to :user

  scope :active, -> { where(created_at: LIFETIME.ago..) }
end
