require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:michael)
    @another_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
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
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as @user
    get edit_user_path(@another_user)

    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as @user
    patch user_path(@another_user), params: {
            user: {
              name: 'valid_name',
              email: 'valid_email@example.com',
              password: "valid_password",
              password_confirmation: "valid_password",
            }
          }

    assert flash.empty?
    assert_redirected_to root_url
  end
end
