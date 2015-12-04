class UserProfilesController < ApplicationController
  before_action :authenticate_user!

  # GET /users/1/profile
  def profile
    @profile_user = User.find(profile_params)

    @created_polls = @profile_user.user_polls
    @created_polls = @created_polls[0...6] if @created_polls.length >= 6

    @voted_polls = UserVote.includes(:user_poll).where(user_id: @profile_user.id).limit(6)
    @voted_polls = @voted_polls.map { |vote| vote.user_poll }

    @user_friends = @profile_user.friendships_to.map { |friendship| User.find(friendship.friend_id) }
    @user_friends += @profile_user.friendships_from.map { |friendship| User.find(friendship.user_id) }
  end

  private
  def profile_params
    params.require(:id)
  end

end
