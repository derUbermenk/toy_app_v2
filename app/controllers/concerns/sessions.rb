module Sessions

  # gets the current user signed in
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # logs in the given user
  #   does so by adding a session cookie containing the encrypted user id
  # @params user [User]
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end

  # logs out the user
  #   deletes the session cookie created login method
  #   deletes the current_user instance model
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def authenticate_user
    if logged_in?
      true
    else
      flash[:warning] = 'You need to sign in before you do that'
      redirect_to login_path
    end
  end
end