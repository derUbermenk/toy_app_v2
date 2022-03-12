module Sessions

  # gets the current user signed in
  def current_user
    if (user_id = session[:user_id]) 
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # logs in the given user
  #   does so by adding a session cookie containing the encrypted user id
  # @params user [User]
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def logged_in?
    !current_user.nil?
  end

  # forgets persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    @current_user = nil
  end

  # logs out the user
  #   deletes the session cookie created login method
  #   deletes the current_user instance model
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def authenticate_user
    if logged_in?
      true
    else
      redirect_to login_path
    end
  end
end