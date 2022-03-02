require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = create :user
  end

  test 'it should get show' do
    get user_path(@user.id)
    assert_response :success
  end
end
