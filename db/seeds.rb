password = if Rails.env.production?
  ENV.fetch("ADMIN_PASSWORD") { raise "ADMIN_PASSWORD must be set in production" }
else
  ENV.fetch("ADMIN_PASSWORD", "password")
end

admin = User.find_or_initialize_by(email_address: "admin@griffithict.club")
admin.password = password if admin.new_record?
admin.role = :admin
admin.save!
