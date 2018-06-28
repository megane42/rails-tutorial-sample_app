require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:michael)
  end

  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email: @user.email, password: 'password' } }

    assert_redirected_to user_path(@user)

    follow_redirect!

    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    assert_select "form[action=\"#{login_path}\"][method=post]"

    post login_path, params: { session: { email: "", password: "" } }

    assert_template "sessions/new"
    assert_select "form[action=?][method=post]", login_path
    assert_select "div.alert-danger"

    get root_path
    assert_select "div.alert-danger", count: 0
  end
end
