class EventRsvpsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_event

  def create
    unless @event.rsvp_open?
      redirect_to event_path(@event.slug), alert: "RSVPs are closed for this event."
      return
    end

    @rsvp = EventRsvp.new(rsvp_params.merge(event_slug: @event.slug))

    if @rsvp.save
      redirect_to event_path(@event.slug), notice: "Your RSVP has been recorded."
    else
      render "events/show", status: :unprocessable_content
    end
  end

  private

  def set_event
    @event = EventCatalog.find!(params[:event_slug])
  end

  def rsvp_params
    params.require(:event_rsvp).permit(:full_name, :student_number, :membership_confirmed)
  end
end
