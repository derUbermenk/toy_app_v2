require "test_helper"

class SignupFlowTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test 'with correct signup fields' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: 'Email',
          email: 'user@example.com',
          password: 'user@example.com',
          password: 'user@example.com' } }
    end
    follow_redirect!

    # redirects to profile of the newly signed in user
    assert_template 'users/show'
    assert_select 'span#username', 'Email'
    assert_select 'span#email', 'user@example.com'

    # logs in user
    assert is_logged_in?
  end

  test 'with incorrect signup fields' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: 'Email',
          email: 'user@example.com',
          password: 'ivb',
          password_confirmation: '@.com' } }
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'

    # does not log in user
    assert_not is_logged_in?
  end
end
