User.find_or_create_by!(email_address: "admin@griffithict.club") do |user|
  user.password = ENV.fetch("ADMIN_PASSWORD", "password")
  user.role = :admin
end
