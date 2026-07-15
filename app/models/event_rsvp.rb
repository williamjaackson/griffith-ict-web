class EventRsvp < ApplicationRecord
  STUDENT_EMAIL_PATTERN = /\A[^@\s]+@griffithuni\.edu\.au\z/i
  STUDENT_NUMBER_PATTERN = /\As\d{6,8}\z/i

  validates :event_slug, :full_name, :student_email, :student_number, presence: true
  validates :full_name, length: { maximum: 120 }
  validates :student_email,
    format: { with: STUDENT_EMAIL_PATTERN, message: "must be a Griffith student email ending in @griffithuni.edu.au" },
    uniqueness: { scope: :event_slug, message: "has already been used to RSVP for this event" }
  validates :student_number,
    format: { with: STUDENT_NUMBER_PATTERN, message: "must start with s followed by 6 to 8 digits" },
    uniqueness: { scope: :event_slug, message: "has already been used to RSVP for this event" }

  normalizes :full_name, with: ->(value) { value.strip }
  normalizes :student_email, with: ->(value) { value.strip.downcase }
  normalizes :student_number, with: ->(value) { value.delete(" ").downcase }
end
