class EventsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_event, only: :show

  def index
    @upcoming_events = EventCatalog.upcoming
    @past_events = EventCatalog.past
  end

  def show
    @rsvp = EventRsvp.new(event_slug: @event.slug)
  end

  private

  def set_event
    @event = EventCatalog.find!(params[:slug])
  end
end
