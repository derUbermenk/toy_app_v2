class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]
  before_action :authenticate_user, except: %i[new create]
  before_action :confirm_ownership, only: %i[edit update destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
     
    if @user.save
      log_in @user
      redirect_to @user 
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
  end

  def destroy
    log_out
    @user.destroy

    flash[:success] = 'Account deleted'
    redirect_to login_path
  end

  private

  def set_user
    @user = params[:id] ? User.find_by(id: params[:id]) : current_user 

    if @user.nil?
      flash[:warning] = 'Please login to access profile' 
      redirect_to login_path
    end
  end

  # confirm if the profile being edited, updated or destroyed is the current users
  def confirm_ownership
    if @user == current_user
      @user #continue
    else
      flash[:warning] = 'You can\'t mess with other profiles' 
      redirect_to profile_path 
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
