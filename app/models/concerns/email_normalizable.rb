module EmailNormalizable
  extend ActiveSupport::Concern

  MAX_EMAIL_LENGTH = 254
  NORMALIZER = ->(email) { email.strip.downcase }

  class_methods do
    def normalizes_email(attribute)
      normalizes attribute, with: NORMALIZER
      validates attribute,
        presence: true,
        length: { maximum: MAX_EMAIL_LENGTH },
        format: { with: URI::MailTo::EMAIL_REGEXP }
    end

    def normalize_email(email)
      NORMALIZER.call(email.to_s)
    end
  end
end
