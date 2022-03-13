require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:ch) 
  end

  test 'it should get signup' do
    get signup_path 

    assert_response :success
  end

  test 'it should get show' do
    login(@user)
    get user_path(@user.id)

    assert_response :success
  end

  test 'it should redirect to signup when trying to edit but not logged in' do
    get edit_user_path(@user.id)

    follow_redirect!

    assert_template 'sessions/new'
  end

  test 'it should get edit profile when logged in' do
    login(@user)

    get edit_user_path(@user) 

    assert_template 'users/edit'
  end

  test 'it cannot edit, delete and update other users profiles' do
    
    login(@user)

    # try edit 
    get edit_user_path(users(:mv))

    follow_redirect!

    # redirects to profile
    assert_template 'users/show'
    assert_select 'div#email', 'ch@email.com'
    assert_select 'div.alert.alert-warning', 'You can\'t mess with other profiles'

    # try update
    put user_path(users(:mv)), params: {
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
    assert_select 'div#email', 'ch@email.com'
    assert_select 'div.alert.alert-warning', 'You can\'t mess with other profiles'

    # try delete
    delete user_path(users(:mv))

    follow_redirect!

    # redirects to profile
    assert_template 'users/show'
    assert_select 'div#email', 'ch@email.com'
    assert_select 'div.alert.alert-warning', 'You can\'t mess with other profiles'
  end

  test 'it cannot delete other users unless own' do
    login(@user)

    # delete another user
    delete user_path(users(:mv))

    follow_redirect!

    # redirects to profile
    assert_template 'users/show'
    assert_select 'div#email', 'ch@email.com'
  end

  test 'it logs out current_user when deleting account' do
    login(@user)

    delete user_path(@user)

    follow_redirect!

    # redirects to profile
    assert_template 'sessions/new'
    assert_select 'div.alert.alert-success', 'Account deleted'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)

    # assert that redirected to login page
    follow_redirect!

    assert_template 'sessions/new'
    assert_select 'div.alert.alert-danger', 'Please log in.'
    login(@user)

    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    assert_template 'users/edit'

    patch user_path(@user), params: { 
      user: { 
        name: 'new name',
        email: 'new@email.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }

    assert_redirected_to @user
  end
end
