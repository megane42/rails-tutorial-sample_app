require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:michael)
  end

  test "successful edit" do
    get edit_user_path(@user)

    assert_template 'users/edit'

    new_name = 'new_name'
    new_mail = 'new_mail@example.com'
    patch user_path(@user), params: {
            user: {
              name: new_name,
              email: new_mail,
              password: "",
              password_confirmation: "",
            }
          }

    assert_not flash.empty?
    assert_redirected_to user_path(@user)

    follow_redirect!
    @user.reload

    assert_equal new_name, @user.name
    assert_equal new_mail, @user.email
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)

    assert_template 'users/edit'

    patch user_path(@user), params: {
           user: {
             name: "",
             email: "user@invalid",
             password: "foo",
             password_confirmation: "bar",
           }
          }

    assert_template 'users/edit'
    assert_select 'div.alert-danger', 'The form contains 4 errors.'
  end
end
