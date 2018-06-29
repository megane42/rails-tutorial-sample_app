require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:michael)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: {
            user: {
              name: 'valid_name',
              email: 'valid_email@example.com',
              password: "valid_password",
              password_confirmation: "valid_password",
            }
          }

    assert_not flash.empty?
    assert_redirected_to login_path
  end
end
