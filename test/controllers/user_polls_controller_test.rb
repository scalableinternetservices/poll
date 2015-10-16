require 'test_helper'

class UserPollsControllerTest < ActionController::TestCase
  setup do
    @user_poll = user_polls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_polls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_poll" do
    assert_difference('UserPoll.count') do
      post :create, user_poll: { create_date: @user_poll.create_date, description: @user_poll.description, title: @user_poll.title }
    end

    assert_redirected_to user_poll_path(assigns(:user_poll))
  end

  test "should show user_poll" do
    get :show, id: @user_poll
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_poll
    assert_response :success
  end

  test "should update user_poll" do
    patch :update, id: @user_poll, user_poll: { create_date: @user_poll.create_date, description: @user_poll.description, title: @user_poll.title }
    assert_redirected_to user_poll_path(assigns(:user_poll))
  end

  test "should destroy user_poll" do
    assert_difference('UserPoll.count', -1) do
      delete :destroy, id: @user_poll
    end

    assert_redirected_to user_polls_path
  end
end
