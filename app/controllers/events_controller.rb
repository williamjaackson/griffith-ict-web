class EventsController < ApplicationController
  allow_unauthenticated_access

  def index
    @upcoming_events = EventCatalog.upcoming
    @past_events = EventCatalog.past
  end

  def show
    @event = EventCatalog.find(params[:slug])
    head :not_found unless @event
  end
end
