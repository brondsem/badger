class AttendeesController < ApplicationController
  before_action :find_attendee, only: [:show, :edit, :update, :destroy]
  before_action :find_event, only: [:index, :new, :edit, :import_csv, :export_blanks]

  def index
    @attendees = @event.attendees.alphabetical.includes(:role)
  end

  def new
    @attendee = Attendee.new
  end

  def create
    @event = Event.find(params[:event_id])
    @attendee = @event.attendees.new(attendee_params)

    if @attendee.save
      redirect_to event_attendees_path(params[:event_id])
    else
      render :new
    end
  end

  def edit
    @attendee = @event.attendees.find(params[:id])
  end

  def update
    if @attendee.update_attributes(attendee_params)
      flash[:notice] = "Successfully updated attendee."
      redirect_to event_attendees_path(@attendee.event)
    else
      flash[:alert] = "Unable to update attendee."
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
    if @attendee.destroy
      flash[:notice] = "Successfully removed attendee #{@attendee.name}."
      redirect_to event_attendees_path
    else
      flash[:alert] = "Unable to remove attendee #{@attendee.name}."
      redirect_to event_attendees_path
    end
  end

  def import_csv
    result = ImportAttendees.call({event: @event}.merge(import_params))

    if result.success?
      flash[:notice] = "Imported Attendees"
      redirect_to event_attendees_path
    else
      flash[:alert] = result.message
      redirect_to import_event_attendees_path
    end
  end

  def export
    result = ExportAttendees.call(attendees: Attendee.alphabetical.includes(:role))
    send_data result.pdf.render, filename: 'badges.pdf', type: 'application/pdf', disposition: 'inline'
  end

  def export_blanks
    result = ExportAttendees.call(blanks: true, event: @event)
    send_data result.pdf.render, filename: 'blank_badges.pdf', type: 'application/pdf', disposition: 'inline'
  end

  private

  def attendee_params
    params.require(:attendee).permit(:first_name, :last_name, :email, :registration_key, :preferences, :role_id, :checked_in, :exported)
  end

  def find_attendee
    @event = Event.find(params[:event_id])
    @attendee = @event.attendees.find(params[:id])
  end

  def find_event
    @event = Event.find(params[:event_id])
  end

  def import_params
    params.permit(:file)
  end
end
