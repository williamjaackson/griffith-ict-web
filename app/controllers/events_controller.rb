class EventsController < ApplicationController
  allow_unauthenticated_access

  def index
    @upcoming_events = EventCatalog.upcoming
    @past_events = EventCatalog.past
  end

  def show
    @event = EventCatalog.find(params[:slug])
    return head :not_found unless @event

    @rsvp = EventRsvp.new(event_slug: @event.slug)
  end
end
