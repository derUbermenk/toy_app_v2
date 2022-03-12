require "test_helper"

class SessionsFlowTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.first 
  end

  test 'login' do
    login(@user)

    assert is_logged_in?

    follow_redirect!

    assert_template 'toys/index'
  end

  test 'logout' do
    login(@user)

    delete logout_path

    assert_not is_logged_in?
  end

  # case where user has two tabs open in
  #   one browser
  test 'logout when already logged out' do
    delete logout_path

    assert_not is_logged_in?
  end

  test 'login with remembering' do
    # login, remembering is default
    login(@user)

    assert_not_empty cookies[:remember_token]
  end

  test 'login without remembering' do
    # login to set cookie
    login(@user)

    # login again and confirm that cookie was deleted
    login(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end

end
