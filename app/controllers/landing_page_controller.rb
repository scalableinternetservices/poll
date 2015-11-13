class LandingPageController < ApplicationController
  before_action :authenticate_user!

  # GET /
  def index
    num_news_feed_polls = 5
    @news_feed_polls, @can_show_more_news_feed_polls = get_news_feed_polls(num_news_feed_polls)
    @next_news_feed_polls_request_size = 10

    num_current_user_polls = 5
    @current_user_polls, @can_show_more_current_user_polls = get_current_user_polls(num_current_user_polls)
    @next_current_user_polls_request_size = 10

    num_current_user_friends = 5
    @current_user_friends = get_current_user_friends(num_current_user_friends)
    @can_show_more_current_user_friends = can_request_more_current_user_friends?(num_current_user_friends)
    @next_current_user_friends_request_size = 10

    @current_user_friend_requests = get_current_user_pending_friendships.map { |friendship|
      requestor = User.find(friendship.requestor_id)
      ["#{requestor.first_name} #{requestor.last_name}", friendship.id]
    }
  end

  # GET /search_polls
  def search_polls
    cleaned_params = search_polls_params
    num_search_polls = cleaned_params[:num_search_polls].to_i
    search = cleaned_params[:search]
    @search_polls, @can_show_more_search_polls = get_polls(num_search_polls, search)
    @next_search_polls_request_size = num_search_polls + 5
    render(layout: false)
  end

  # GET /news_feed_polls
  def news_feed_polls
    num_news_feed_polls = news_feed_polls_params.to_i
    @news_feed_polls, @can_show_more_news_feed_polls = get_news_feed_polls(num_news_feed_polls)
    @next_news_feed_polls_request_size = num_news_feed_polls + 5
    render(layout: false)
  end

  # GET /current_user_polls
  def current_user_polls
    num_current_user_polls = current_user_polls_params.to_i
    @current_user_polls, @can_show_more_current_user_polls = get_current_user_polls(num_current_user_polls)
    @next_current_user_polls_request_size = num_current_user_polls + 5
    render(layout: false)
  end

  # GET /friends_pane
  def friends_pane
    num_current_user_friends = friends_pane_params.to_i
    @current_user_friends = get_current_user_friends(num_current_user_friends)
    @can_show_more_current_user_friends = can_request_more_current_user_friends?(num_current_user_friends)
    @next_current_user_friends_request_size = num_current_user_friends + 5

    @current_user_friend_requests = get_current_user_pending_friendships.map { |friendship|
      requestor = User.find(friendship.requestor_id)
      ["#{requestor.first_name} #{requestor.last_name}", friendship.id]
    }

    render(layout: false)
  end

  # GET /friends_for_sharing
  def friends_for_sharing
    cleaned_params = friends_for_sharing_params
    @friends = get_current_user_friends(cleaned_params[:num_friends].to_i)
    @poll_id = cleaned_params[:poll_id]

    render(layout: false)
  end

  private
    def search_polls_params
      params.require(:num_search_polls, :search)
    end

    def news_feed_polls_params
      params.require(:num_news_feed_polls)
    end
    
    def current_user_polls_params
      params.require(:num_current_user_polls)
    end

    def friends_pane_params
      params.require(:num_current_user_friends)
    end

    def friends_for_sharing_params
      params.permit(:num_friends, :poll_id)
    end

    def get_polls(max_num_polls, search)
      if (search and search.length > 0)
        #Break search string into words
        words = search.blank? ? [] : search.split(' ')
        conditions = [[]] # Why this way? You'll know soon
        words.each do |word|
          conditions[0] << ["title LIKE ?"]
          conditions << "%#{word}%"
        end
        conditions[0] = conditions.first.join(" OR ") # Converts condition string to include " OR " easily ;-)
        conditions[0] << "AND user_id != #{current_user.id}"
        
        # Grab one more poll than requested so that we can determine if there are more polls to show
        polls = UserPoll.where(conditions).limit(max_num_polls).all

        can_show_more = (polls.length > max_num_polls)
        polls = polls[0...max_num_polls] if can_show_more

        return polls, can_show_more
      end

      return [], false
    end

    # Algorithm for choosing news feed polls
    def get_news_feed_polls(max_num_polls)
      # For now, nothing fancy. Just choose the newest polls that are not yours.

      # Grab one more poll than requested so that we can determine if there are more polls to show
      polls = UserPoll.where.not(user_id: current_user.id).order(updated_at: :desc).limit(max_num_polls + 1).all
      
      can_show_more = (polls.length > max_num_polls)
      polls = polls[0...max_num_polls] if can_show_more
      
      return polls, can_show_more
    end

    def get_current_user_polls(max_num_polls)
      # Grab one more poll than requested so that we can determine if there are more polls to show
      polls = UserPoll.where(user_id: current_user.id).order(updated_at: :desc).limit(max_num_polls + 1).all

      can_show_more = (polls.length > max_num_polls)
      polls = polls[0...max_num_polls] if can_show_more
      
      return polls, can_show_more
    end

    def get_current_user_friends(max_num_friends)
      # Show the friends in alphabetical order
      all_friends = current_user.friendships_to.map { |friendship| User.find(friendship.friend_id) } + current_user.friendships_from.map { |friendship| User.find(friendship.user_id) }
      all_friends.sort! { |a, b| ("#{a.first_name} #{a.last_name}").casecmp("#{b.first_name} #{b.last_name}") }
      all_friends = all_friends[0...max_num_friends] if all_friends.length > max_num_friends

      return all_friends
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
