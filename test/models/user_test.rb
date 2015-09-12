require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "name should be less than 50" do
    @user.name = 'a'*51
    assert_not @user.valid?
  end
  
  test "email should be less than 255" do
    @user.email = 'a'*266;
    assert_not @user.valid?
  end
  
  test "validate email address " do
    invalid_address = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_address.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address} should be invalid"
    end
  end
  
  test "emai id should be unique" do
    d_user = @user.dup
    @user.save
    assert_not d_user.valid?
    @user.delete
  end
  
  test "emai id should be case insestive" do
    d_user = @user.dup
    @user.save
    d_user.email = @user.email.upcase
    assert_not d_user.valid?
    @user.delete
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end
