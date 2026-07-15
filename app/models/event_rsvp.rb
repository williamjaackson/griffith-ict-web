class EventRsvp < ApplicationRecord
  STUDENT_NUMBER_PATTERN = /\As\d{7}\z/i

  before_validation :derive_student_email

  validates :event_slug, :full_name, :student_number, presence: true
  validates :full_name, length: { maximum: 120 }
  validates :student_number,
    format: { with: STUDENT_NUMBER_PATTERN, message: "must look like s1234567" },
    uniqueness: { scope: :event_slug, message: "has already been used to RSVP for this event" }
  validates :student_email, uniqueness: { scope: :event_slug }, allow_nil: true
  validates :membership_confirmed, acceptance: { accept: true }

  normalizes :full_name, with: ->(value) { value.strip }
  normalizes :student_email, with: ->(value) { value.strip.downcase }
  normalizes :student_number, with: ->(value) { value.delete(" ").downcase }

  private

  def derive_student_email
    self.student_email = student_number&.match?(STUDENT_NUMBER_PATTERN) ? "#{student_number}@griffithuni.edu.au" : nil
  end
end
