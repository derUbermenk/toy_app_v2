require "test_helper"

class SessionsFlowTest < ActionDispatch::IntegrationTest
  def setup
    @user = create :user
  end

  test 'login' do
    post login_path, params: {
      session: {
        email: @user.email,
        password: 'password'
      }
    }

    assert is_logged_in?

    follow_redirect!

    assert_template 'toys/index'
  end

  test 'logout' do
    delete logout_path

    assert_not is_logged_in?
  end
end
