class AttendeesController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
    @attendee = @event.attendees.new
  end

  def create
    @event = Event.find(params[:event_id])
    @attendee = @event.attendees.build(attendee_params)

    if @attendee.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @attendee = @event.attendees.find(params[:id])
  end

  def update
    @event = Event.find(params[:event_id])

    if @event.attendees.find(params[:id]).update(attendee_params)
      redirect_to event_path(@event)
    else
      render :edit
    end
  end

  def export
    event = Event.find(params[:event_id])
    attendees = event.attendees.includes(:role).alphabetical

    if attendees.not_exported.present?
      result = ExportAttendees.call(attendees: attendees, event: event)
      send_data result.pdf.render, filename: 'badges.pdf', type: 'application/pdf', disposition: 'inline'
    else
      flash[:alert] = "No Attendees to Export (PDF)"
      redirect_to event_path(event)
    end
  end

  def export_blanks
    event = Event.find(params[:event_id])

    result = ExportAttendees.call(event: event, blanks: true)
    send_data result.pdf.render, filename: 'badges.pdf', type: 'application/pdf', disposition: 'inline'
  end

  def destroy
    @event = Event.find(params[:event_id])

    attendee = @event.attendees.find(params[:id])
    attendee.destroy

    redirect_to event_path(@event)
  end

  private

  def attendee_params
    params.require(:attendee).permit(:first_name, :last_name, :email, :registration_key, :preferences, :role_id, :checked_in, :exported)
  end

end
