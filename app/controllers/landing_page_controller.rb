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
  # DEPRECATED
    def news_feed_polls_params
      params.permit(:num_news_feed_polls)
    end
    
  # DEPRECATED
    def current_user_polls_params
      params.permit(:num_current_user_polls)
    end

  # DEPRECATED
    # Algorithm for choosing news feed polls
    def get_news_feed_polls(max_num_polls)
      # For now, nothing fancy. Just choose the newest polls that are not yours.
      ::UserPoll.where.not(user_id: current_user.id).order(updated_at: :desc).limit(max_num_polls)
    end

  # DEPRECATED
    def get_current_user_polls(max_num_polls)
      UserPoll.where(user_id: current_user.id).order(updated_at: :desc).limit(max_num_polls)
    end

  # DEPRECATED
    def can_request_more_news_feed_polls?(num_polls)
      num_polls < UserPoll.where.not(user_id: current_user.id).count
    end

  # DEPRECATED
    def can_request_more_current_user_polls?(num_polls)
      num_polls < UserPoll.where(user_id: current_user.id).count
    end
end
