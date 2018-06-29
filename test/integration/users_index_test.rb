require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as @user
    get users_path

    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |u|
      assert_select 'a[href=?]', user_path(u), text: u.name
    end
  end
end
