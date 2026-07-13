if Rails.env.production? && ENV["DATABASE_URL"].blank?
  raise "DATABASE_URL must be set in production"
end
