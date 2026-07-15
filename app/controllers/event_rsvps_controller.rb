class EventRsvpsController < ApplicationController
  allow_unauthenticated_access

  def create
    @event = EventCatalog.find(params[:event_slug])
    return head :not_found unless @event

    unless @event.rsvp_open?
      redirect_to event_path(@event.slug), alert: "RSVPs are closed for this event."
      return
    end

    @rsvp = EventRsvp.new(rsvp_params.merge(event_slug: @event.slug))

    if @rsvp.save
      redirect_to event_path(@event.slug, anchor: "rsvp"), notice: "Your RSVP has been recorded. No automated email was sent."
    else
      render "events/show", status: :unprocessable_content
    end
  end

  private

  def rsvp_params
    params.require(:event_rsvp).permit(:full_name, :student_email, :student_number)
  end
end
