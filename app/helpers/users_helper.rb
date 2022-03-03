module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 64)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=robohash&s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
