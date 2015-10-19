class ImportController < ApplicationController
  def attendees
    @event = Event.find(params[:event_id])
    result = ImportAttendees.call({event: @event}.merge(import_params))

    if result.success?
      flash[:notice] = "Imported Attendees"
      redirect_to event_path(@event)
    else
      flash[:alert] = result.message
      redirect_to import_event_attendees_path(@event)
    end
  end

  private

  def import_params
    params.permit(:file)
  end
end
