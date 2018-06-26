require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    assert_select "form[action=\"#{login_path}\"][method=post]"

    post login_path, params: { session: { email: "", password: "" } }

    assert_template "sessions/new"
    assert_select "form[action=\"#{login_path}\"][method=post]"
    assert_select "div.alert-danger"

    get root_path
    assert_select "div.alert-danger", false
  end
end
