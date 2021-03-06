module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_url(user, size: 64)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=robohash&s=#{size}"
  end

  def is_current_user?
    user == current_user
  end
end
