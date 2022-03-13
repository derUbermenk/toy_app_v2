class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]
  before_action :authenticate_user, except: %i[new create]
  before_action :confirm_owner_or_admin, only: %i[edit update destroy]

  def index
    @current_user = current_user
    @users = User.where.not('email = ?', current_user.email)
  end

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
    # log out unless current user is an admin and is deleting another account.

    flash[:success] = 'Account deleted'
    @user.destroy
    if (current_user.admin? & current_user != @user)
      redirect_back(fallback_location: users_path)
    else
      log_out
      redirect_to login_path
    end
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
  def confirm_owner_or_admin
    if @user == current_user || current_user.admin?
      @user #continue
    else
      flash[:warning] = 'You can\'t mess with other profiles' 
      redirect_to profile_path 
    end
  end

  # admin param not permitted to avoid allowing users
  #   to set and create admin accounts
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
