Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri :self
    policy.connect_src :self
    policy.font_src :self, "https://fonts.gstatic.com"
    policy.form_action :self
    policy.frame_ancestors :none
    policy.img_src :self, :data
    policy.manifest_src :self
    policy.object_src :none
    policy.script_src :self
    policy.style_src :self, "https://fonts.googleapis.com"
  end

  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src]
  config.content_security_policy_nonce_auto = true
end
