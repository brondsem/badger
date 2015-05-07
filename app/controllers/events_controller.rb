class EventsController < ApplicationController
  before_action :find_event, only: [:show, :edit, :update, :destroy]

  def index
    if current_user.admin
      @events = Event.upcoming
    else
      @events = current_user.events.upcoming
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    @event.users << current_user

    if @event.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def update
    if @event.update_attributes(event_params)
      flash[:notice] = "Successfully updated event."
      redirect_to events_path
    else
      flash[:alert] = "Unable to update event."
      render :edit
    end
  end

  def destroy
    if @event.destroy
      flash[:notice] = "Successfully removed event #{@event.name}."
      redirect_to events_path
    else
      flash[:alert] = "Unable to remove event."
      redirect_to events_path
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :start_date, :end_date, :logo)
  end

  def find_event
    @event = Event.find(params[:id])
  end
end
