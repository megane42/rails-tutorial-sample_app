require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "valid signup information" do
    get signup_path
    assert_template "users/new"
    assert_select "form[id=new_user][action=\"#{signup_path}\"]"

    assert_difference 'User.count', 1 do
      post signup_path, params: {
             user: {
               name: "Example User",
               email: "user@example.com",
               password: "asdfasdf",
               password_confirmation: "asdfasdf",
             }
           }
    end

    follow_redirect!
    assert_template "users/show"
    assert_select "div.alert-success"
    assert is_logged_in?
  end


  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_select "form[id=new_user][action=\"#{signup_path}\"]"

    assert_no_difference 'User.count' do
      post signup_path, params: {
             user: {
               name: "",
               email: "user@invalid",
               password: "foo",
               password_confirmation: "bar"
             }
           }
    end

    assert_template 'users/new'
    assert_select "form[id=new_user][action=\"#{signup_path}\"]"
    assert_select 'div#error_explanation div.alert-danger', /4 errors/
  end
end
