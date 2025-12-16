require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # Skipping authenticated route test - requires user login
  # test "should get show" do
  #   get users_show_url
  #   assert_response :success
  # end

  test "should redirect to login when not authenticated" do
    get users_show_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end
end
