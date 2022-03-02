require "test_helper"

class ToysControllerTest < ActionDispatch::IntegrationTest
  def setup
    @toy = create :toy
  end

  test 'it should get new' do
    get new_toy_path
    assert_response :success
  end

  test 'it should get edit' do
    get edit_toy_path(@toy)
    assert_response :success
  end
end
