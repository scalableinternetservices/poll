class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  # GET /friend_request/new
  def new
  end

  # GET /friend_request/search_users
  def search_users
    permitted_params = search_users_params
    search_field = permitted_params[:search_field]
    results_size = permitted_params[:results_size]
    results_size = 5 if results_size == nil
    
    keywords = search_field.split

    if keywords.length == 1
      # Search first name, then last name
      @matching_users = User.where(first_name: keywords[0]).limit(results_size)
      
      if @matching_users.length < results_size
        @matching_users += User.where(last_name: keywords[0]).limit(results_size - @matching_users.length)
      end
    elsif keywords.length >= 2
      # Search both first and last name. For now, ignore anything except the first two keywords
      @matching_users = User.where(first_name: keywords[0], last_name: keywords[1]).limit(results_size)
    else
      @matching_users = []
    end

    render(layout: false)
  end

  # POST /friend_request/create/1
  def create
    friend_id = friend_request_params

    pending_friendship = PendingFriendship.new
    pending_friendship.requestor_id = current_user.id
    pending_friendship.receiver_id = friend_id

    respond_to do |format|
      if pending_friendship.save
        format.html { redirect_to root_path, notice: 'Friend request successfully sent.' }
      else
        format.html { render :new, notice: 'Friend request failed.' }
      end
    end
  end

  # POST /friend_request/accept/1
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

  # POST /friend_request/reject/1
  def reject
    pending_friendship = PendingFriendship.find(accept_reject_params)
    pending_friendship.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Successfully rejected friend request' }
    end
  end

  def get_friend_action(user)
    if user == current_user
      return "It's you!"
    end

    already_friends = (Friendship.where(user_id: current_user.id, friend_id: user.id).count >= 1) || (Friendship.where(user_id: user.id, friend_id: current_user.id).count >= 1)

    if already_friends
      return "Already friends"
    end

    already_sent_request = PendingFriendship.where(requestor_id: current_user.id, receiver_id: user.id).count >= 1
    if already_sent_request
      return "Already sent friend request"
    end

    received_requests = PendingFriendship.where(requestor_id: user.id, receiver_id: current_user.id)
    if received_requests.count >= 1
      return view_context.link_to "Accept friend request", accept_friend_request_path(received_requests[0]), method: :post
    end

    view_context.link_to "Send friend request", create_friend_request_path(user.id), method: :post
  end
  helper_method :get_friend_action

  private
  def friend_request_params
    params.require(:id)
  end

  def accept_reject_params
    params.require(:id)
  end

  def search_users_params
    params.permit(:search_field, :results_size)
  end
end
