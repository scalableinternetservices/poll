class LandingPageController < ApplicationController
  before_action :authenticate_user!

  # GET /
  def index
    num_news_feed_polls = 5
    @news_feed_polls = get_news_feed_polls(num_news_feed_polls)
    @can_show_more_news_feed_polls = can_request_more_news_feed_polls?(num_news_feed_polls)
    @next_news_feed_polls_request_size = 10

    num_current_user_polls = 5
    @current_user_polls = get_current_user_polls(num_current_user_polls)
    @can_show_more_current_user_polls = can_request_more_current_user_polls?(num_current_user_polls)
    @next_current_user_polls_request_size = 10

    num_current_user_friends = 5
    @current_user_friends = get_current_user_friends(num_current_user_friends)
    @can_show_more_current_user_friends = can_request_more_current_user_friends?(num_current_user_friends)
    @next_current_user_friends_request_size = 10

    @current_user_friend_requests = get_current_user_pending_friendships.map { |friendship|
      requestor = User.find(friendship.requestor_id)
      tuple = Array.new(2)
      tuple[0] = "#{requestor.first_name} #{requestor.last_name}"
      tuple[1] = friendship.id
      tuple
    }
  end

  # GET /news_feed_polls
  def news_feed_polls
    num_news_feed_polls = news_feed_polls_params[:num_news_feed_polls].to_i
    @news_feed_polls = get_news_feed_polls(num_news_feed_polls)
    @can_show_more_news_feed_polls = can_request_more_news_feed_polls?(num_news_feed_polls)
    @next_news_feed_polls_request_size = num_news_feed_polls + 5
    render(layout: false)
  end

  # GET /current_user_polls
  def current_user_polls
    num_current_user_polls = current_user_polls_params[:num_current_user_polls].to_i
    @current_user_polls = get_current_user_polls(num_current_user_polls)
    @can_show_more_current_user_polls = can_request_more_current_user_polls?(num_current_user_polls)
    @next_current_user_polls_request_size = num_current_user_polls + 5
    render(layout: false)
  end

  private
    def news_feed_polls_params
      params.permit(:num_news_feed_polls)
    end
    
    def current_user_polls_params
      params.permit(:num_current_user_polls)
    end

    # Algorithm for choosing news feed polls
    def get_news_feed_polls(max_num_polls)
      # For now, nothing fancy. Just choose the newest polls that are not yours.
      ::UserPoll.where.not(user_id: current_user.id).order(updated_at: :desc).limit(max_num_polls)
    end

    def get_current_user_polls(max_num_polls)
      UserPoll.where(user_id: current_user.id).order(updated_at: :desc).limit(max_num_polls)
    end

    def get_current_user_friends(max_num_friends)
      # For now show some arbitrary number of friends.

      # If friendships_to is large enough, just return the first max_num_friends entries from that.
      if current_user.friendships_to.length >= max_num_friends
        return current_user.friendships_to[0...max_num_friends].map { |friendship|
          User.find(friendship.friend_id)
        }
      end

      # Otherwise, first use as many friendships_to as you can...
      friends = current_user.friendships_to.map { |friendship|
        User.find(friendship.friend_id)
      }

      # ...and fill the rest with as many friendships_from as you can
      range_end = [current_user.friendships_from.length, max_num_friends - friends.length].min
      other_friends = current_user.friendships_from[0...range_end].map { |friendship|
        User.find(friendship.user_id)
      }

      return friends + other_friends
    end

    def get_current_user_pending_friendships
      PendingFriendship.where(receiver_id: current_user.id)
    end

    def can_request_more_news_feed_polls?(num_polls)
      num_polls < UserPoll.where.not(user_id: current_user.id).count
    end

    def can_request_more_current_user_polls?(num_polls)
      num_polls < UserPoll.where(user_id: current_user.id).count
    end

    def can_request_more_current_user_friends?(num_friends)
      num_friends < current_user.friendships_to.length + current_user.friendships_from.length
    end
end
