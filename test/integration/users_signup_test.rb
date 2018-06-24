require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
