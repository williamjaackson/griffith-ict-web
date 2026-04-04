password = if Rails.env.production?
  ENV.fetch("ADMIN_PASSWORD") { raise "ADMIN_PASSWORD must be set in production" }
else
  ENV.fetch("ADMIN_PASSWORD", "password")
end

User.find_or_create_by!(email_address: "admin@griffithict.club") do |user|
  user.password = password
  user.role = :admin
end
