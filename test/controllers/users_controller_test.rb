require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:dhwanit)
    @other_user = users(:archer)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect to login if not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect to login while update and not logged in" do
    patch :update, id: @user, user: {name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "Not allow to edit other user information" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "Not allow to update other user information" do
    log_in_as(@other_user)
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end
end
