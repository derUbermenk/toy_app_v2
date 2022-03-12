class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])

    # &. -- safe navigation
    # returns nil if user is nil otherwise calls authenticate
    if user&.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1'  ? remember(user) : forget(user)
      flash[:success] = "Welcome back #{user.name}!"
      redirect_to root_path 
    else
      flash.now[:danger] = 'Invalid email/password'
      render 'new'
    end
  end

  def destroy
    # handles the case where the user could have opened 2 tabs in one
    #   browser. Logging out in first tab will delete the session cookie.
    #   Trying to log out in the second tab will then lead to the code  
    #   to try to delete a non existent session cookie. So if the session cookie
    #   is not present anymore ( logged_in?  == false ), do not try to log_out anymore.
    #   The absence of the action cookie will result to the client being required to
    #   log out anyway
    log_out if logged_in?
    flash[:success] = 'Logged out successfully'
    redirect_to login_path
  end
end
