require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: "asdfasdf",
      password_confirmation: "asdfasdf",
    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should exist" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should exist" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  %w(user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn).each do |valid_address|
    test "email (#{valid_address}) should be accepted as valid format" do
      @user.email = valid_address
      assert @user.valid?
    end
  end

  %w(user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com).each do |invalid_address|
    test "email (#{invalid_address}) should be rejected as invalid format" do
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end

  test "email address should be unique" do
    @user.save
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    assert_not duplicate_user.valid?
  end

  test "email address should be saved in lower case" do
    email_with_upper = "FoO@ExAmPlE.cOm"
    @user.email = email_with_upper
    @user.save
    @user.reload
    assert_equal email_with_upper.downcase, @user.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be long enough" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
