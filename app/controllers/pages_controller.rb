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

  def v6
    render layout: "pop"
  end

  def v7
    render layout: "institutional"
  end

  def v8
    render layout: "brutalist"
  end

  def v9
    render layout: "modern"
  end

  def v10
    render layout: "profile"
  end

  def v11
    render layout: "refined"
  end

  def v12
    render layout: "redbrutalist"
  end

  def v13
    render layout: "v13"
  end
end
