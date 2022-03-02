class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
     
    if @user.save
      redirect_to profile_path 
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
    @user.destroy

    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
