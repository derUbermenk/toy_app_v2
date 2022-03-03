class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]
  before_action :authenticate_user, only: %i[edit update destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
     
    if @user.save
      redirect_to @user 
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
    @user = params[:id] ? User.find_by(id: params[:id]) : current_user 
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
