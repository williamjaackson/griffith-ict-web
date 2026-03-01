class PagesController < ApplicationController
  def home
    render "pages/landing/home"
  end

  def design_system
  end

  def about
    render "pages/about/about"
  end

  def sponsorship
    render "pages/sponsorship/sponsorship"
  end
end
