class OembedController < ApplicationController
  def show
    meta = Rails.application.config.meta

    render json: {
      type: "link",
      version: "1.0",
      author_name: meta[:site_name],
      author_url: meta[:url],
      provider_name: meta[:site_name],
      provider_url: meta[:url]
    }
  end
end
