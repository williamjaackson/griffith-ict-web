require Rails.root.join("lib/site_config")

site_config = SiteConfig.load_all(root: Rails.root.join("config"))

Rails.application.config.site = site_config
Rails.application.config.meta = site_config.fetch(:meta)
Rails.application.config.socials = site_config.fetch(:socials)
