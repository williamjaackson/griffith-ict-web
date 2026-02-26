class PagesController < ApplicationController
  def index
  end

  def v1
  end

  def v2
    render layout: "light"
  end

  def v3
    render layout: "bento"
  end

  def v4
    render layout: "terminal"
  end

  def v5
    render layout: "campus"
  end
end
