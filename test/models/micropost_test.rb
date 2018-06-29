require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  setup do
    @user = users(:michael)
    @micropost = @user.microposts.build( content: 'lorem ipsum' )
  end

  test "should be vald" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be shorter than 140 chars" do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
