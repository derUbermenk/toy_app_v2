class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :random_image

  include Sessions

  def random_image
    widths = [720, 1280]

    "https://picsum.photos/#{widths.sample}/720"
  end
end
