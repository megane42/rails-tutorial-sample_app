require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user      = users(:michael)
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_not is_logged_in?

    post microposts_path, params: {
           micropost: {
             content: "lorem ipsum",
             user_id: @user.id
           }
         }

    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_not is_logged_in?

    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end

    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as @user
    assert is_logged_in?

    post_of_others = microposts(:ants)

    assert_no_difference 'Micropost.count' do
      delete micropost_path(post_of_others)
    end

    assert_redirected_to root_url
  end
end
