require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = create :user
  end

  def login(email, password)
    # log in user first
    post login_path, params: {
      session: {
        email: email,
        password: password
      }
    }

    @current_user = User.find_by(email: email)
  end

  test 'it should get signup' do
    get signup_path 

    assert_response :success
  end

  test 'it should get show' do
    get user_path(@user.id)

    assert_response :success
  end

  test 'it should redirect to signup when trying to edit but not logged in' do
    get edit_user_path(@user.id)
    follow_redirect!

    assert_template 'sessions/new'
  end

  test 'it should get edit profile when logged in' do
    login('ch@email.com', 'password')

    get edit_user_path(@current_user) 

    assert_template 'users/edit'
  end

  test 'it cannot edit, delete and update other users profiles' do
    login('ch@email.com', 'password')

    get edit_user_path(@user)

    follow_redirect!

    # redirects to profile
    assert_template 'users/show'
    assert_select 'span#email', 'ch@email.com'
    assert_select 'div.alert.alert-warning', 'You can\'t mess with other profiles'

    put user_path(@user), params: {
      user: {
        name: 'new name',
        email: 'new@name.com',
        password: 'password',
        password_confirmation: 'password',
      }
    }

    follow_redirect!

    # redirects to profile
    assert_template 'users/show'
    assert_select 'span#email', 'ch@email.com'
    assert_select 'div.alert.alert-warning', 'You can\'t mess with other profiles'
  end

  test 'it cannot delete other users unless own' do
    login('ch@email.com', 'password')

    delete user_path(@user)

    follow_redirect!

    # redirects to profile
    assert_template 'users/show'
    assert_select 'span#email', 'ch@email.com'
    assert_select 'div.alert.alert-warning', 'You can\'t mess with other profiles'
  end

  test 'it logs out current_user when deleting account' do
    login('ch@email.com', 'password')

    delete user_path(@current_user)

    follow_redirect!

    # redirects to profile
    assert_template 'toys/index'
    assert_select 'div.alert.alert-success', 'Account deleted'
  end
end
