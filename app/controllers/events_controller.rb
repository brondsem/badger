class EventsController < ApplicationController
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
      redirect_to events_path
    else
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if @event.update(event_params)
      redirect_to events_path
    else
      render :edit
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to events_path
  end

  private

  def event_params
    params.require(:event).permit(:name, :start_date, :end_date, :logo)
  end
end