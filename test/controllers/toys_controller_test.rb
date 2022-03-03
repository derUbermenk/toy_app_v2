require "test_helper"

class ToysControllerTest < ActionDispatch::IntegrationTest
  def setup
    @toy = create :toy
    @owned_toy = create(:toy, owner: User.find_by(email: 'ch@email.com'))
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

  test 'it should get new' do
    login('ch@email.com', 'password')

    get new_toy_path
    assert_response :success

    assert_template 'toys/new'
  end

  test 'when creating new toy it should require login if not logged in' do
    get new_toy_path
    follow_redirect!
    assert_template 'sessions/new'   
  end

  test 'it should get edit when current_user owns the toy' do
    login('ch@email.com', 'password')

    get edit_toy_path(@owned_toy)
    assert_response :success

    assert_template 'toys/edit'
  end

  test 'it should require login when editing, deleting and updating toys' do
     # edit 
     get edit_toy_path(@toy) 
     follow_redirect!
     assert_template 'sessions/new'   

     # delete
     delete toy_path(@toy)
     follow_redirect!
     assert_template 'sessions/new'

     # update
     patch toy_path(@toy) #no params needed
     follow_redirect!
     assert_template 'sessions/new'
  end

  test 'it should redirect to profile when editiing, deleting or updating non owned toys' do
    login('ch@email.com', 'password')
    
     get edit_toy_path(@toy) 
     follow_redirect!
     assert_template 'users/show'   
     assert_select 'span#email', 'ch@email.com'
     assert_select 'div.alert.alert-warning', 'You can only play with your own toys'


     delete toy_path(@toy) 
     follow_redirect!
     assert_template 'users/show'   
     assert_select 'span#email', 'ch@email.com'
     assert_select 'div.alert.alert-warning', 'You can only play with your own toys'

     patch toy_path(@toy) #no params needed
     follow_redirect!
     assert_template 'users/show'   
     assert_select 'span#email', 'ch@email.com'
     assert_select 'div.alert.alert-warning', 'You can only play with your own toys'
  end

end
