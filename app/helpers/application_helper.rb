module ApplicationHelper
  def site_meta = Rails.application.config.meta
  def site_socials = Rails.application.config.socials

  def page_title = content_for(:title).presence || site_meta[:site_name]
  def page_description = content_for(:meta_description).presence || site_meta[:description]
  def page_image = content_for(:meta_image).presence || "#{site_meta[:url]}#{site_meta[:og_image]}"
  def canonical_url = content_for(:canonical_url).presence

  def preview_environment
    return :preview if ENV["PREVIEW_PR_NUMBER"].present?
    :development if Rails.env.development?
  end
end
