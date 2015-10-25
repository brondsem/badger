class UsersController < ApplicationController
  before_action :authorize!

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def admin_create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id]).destroy

    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :admin, :manager, :event_ids, event_ids: [])
  end
end
