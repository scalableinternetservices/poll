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

  # POST /friend_request/accept
  def accept
    pending_friendship = PendingFriendship.find(accept_reject_params)

    accepted_friendship = Friendship.new
    accepted_friendship.user_id = pending_friendship.requestor_id
    accepted_friendship.friend_id = pending_friendship.receiver_id

    respond_to do |format|
      if accepted_friendship.save
        pending_friendship.destroy

        format.html { redirect_to root_path, notice: 'Successfully accepted friend request' }
      else
        format.html { redirect_to root_path, notice: 'Failure to accept friend request' }
      end
    end
  end

  # POST /friend_request/reject
  def reject
    pending_friendship = PendingFriendship.find(accept_reject_params)
    pending_friendship.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Successfully rejected friend request' }
    end
  end

  private
  def friend_request_params
    params.require(:name)
  end

  def accept_reject_params
    params.require(:id)
  end
end
