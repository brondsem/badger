class RolesController < ApplicationController
  def index
    @event = Event.find(params[:event_id])
  end

  def new
    @event = Event.find(params[:event_id])
    @role = @event.roles.new
  end

  def create
    @event = Event.find(params[:event_id])
    @role = @event.roles.build(role_params)

    if @role.save
      redirect_to event_roles_path(@event)
    else
      render :new
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @role = @event.roles.find(params[:id])
  end

  def update
    @event = Event.find(params[:event_id])

    if @event.roles.find(params[:id]).update(role_params)
      redirect_to event_roles_path(@event)
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:event_id])

    role = @event.roles.find(params[:id])
    role.destroy

    redirect_to event_roles_path(@event)
  end

  private

  def role_params
    params.require(:role).permit(:name, :reference_key)
  end
end
