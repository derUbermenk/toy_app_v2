class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])

    # &. -- safe navigation
    # returns nil if user is nil otherwise calls authenticate
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path 
    else
      flash.now[:danger] = 'Invalid email/password'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:success] = 'Logged out successfully'
    redirect_to root_path
  end
end
