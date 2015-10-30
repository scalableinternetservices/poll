class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  # GET /friend_request/new
  def new
  end

  # POST /friend_request
  def create
    # Currently this method takes the name as a parameter and tries to match it to an existing
    # user, but what should really happen in the future is that a separate lookup of users based
    # on names occurs before sending this request.
    
    full_name = friend_request_params
    names = full_name.split
    if names.length < 2
      return # Do something more intelligent later
    end

    matching_users = User.where(first_name: names[0], last_name: names[1])
    if matching_users.length != 1
      return # Do something more intelligent later
    end

    pending_friendship = PendingFriendship.new
    pending_friendship.requestor_id = current_user.id
    pending_friendship.receiver_id = matching_users[0].id

    respond_to do |format|
      if pending_friendship.save
        format.html { redirect_to root_path, notice: 'Friend request successfully sent.' }
      else
        format.html { render :new, notice: 'Friend request failed.' }
      end
    end
  end

  private
  def friend_request_params
    params.require(:name)
  end
end
