class UserPollsController < ApplicationController
  before_action :set_user_poll, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /user_polls
  # GET /user_polls.json
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

  # GET /user_polls/news_feed_polls
  def news_feed_polls
    num_news_feed_polls = news_feed_polls_params[:num_news_feed_polls].to_i
    @news_feed_polls = get_news_feed_polls(num_news_feed_polls)
    @can_show_more_news_feed_polls = can_request_more_news_feed_polls?(num_news_feed_polls)
    @next_news_feed_polls_request_size = num_news_feed_polls + 5
    render(layout: false)
  end

  # GET /user_polls/current_user_polls
  def current_user_polls
    num_current_user_polls = current_user_polls_params[:num_current_user_polls].to_i
    @current_user_polls = get_current_user_polls(num_current_user_polls)
    @can_show_more_current_user_polls = can_request_more_current_user_polls?(num_current_user_polls)
    @next_current_user_polls_request_size = num_current_user_polls + 5
    render(layout: false)
  end

  # GET /user_polls/1
  # GET /user_polls/1.json
  def show
  end

  # GET /user_polls/new
  def new
    @user_poll = UserPoll.new
    @poll_questions = [ PollQuestion.new ]
    @max_num_questions = UserPoll.MAX_NUM_POLL_QUESTIONS
    @max_num_answers = PollQuestion.MAX_NUM_ANSWERS
  end

  # GET /user_polls/1/edit
  def edit
    @poll_questions = @user_poll.poll_questions
    @max_num_questions = UserPoll.MAX_NUM_POLL_QUESTIONS
    @max_num_answers = PollQuestion.MAX_NUM_ANSWERS
  end

  # POST /user_polls
  # POST /user_polls.json
  def create
    @user_poll = current_user.user_polls.new(user_poll_params)
    @user_poll.poll_questions.each { |poll_question|
      empty_answers = poll_question.answers.select { |answer| answer.text == "" }
      empty_answers.each { |answer| answer.destroy }
    }

    empty_questions = @user_poll.poll_questions.select { |poll_question| poll_question.text == "" or poll_question.answers.length == 0 }
    empty_questions.each { |question| question.destroy }
    
    respond_to do |format|
      if @user_poll.save
        format.html { redirect_to @user_poll, notice: 'User poll was successfully created.' }
        format.json { render :show, status: :created, location: @user_poll }
      else
        format.html { render :new }
        format.json { render json: @user_poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_polls/1
  # PATCH/PUT /user_polls/1.json
  # DISABLED
  def update
    respond_to do |format|
      if @user_poll.update(user_poll_params)
        format.html { redirect_to @user_poll, notice: 'User poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_poll }
      else
        format.html { render :edit }
        format.json { render json: @user_poll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_polls/1
  # DELETE /user_polls/1.json
  def destroy
    respond_to do |format|
      if User.find(@user_poll.user_id) == current_user and @user_poll.destroy
        format.html { redirect_to user_polls_url, notice: 'User poll was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :index }
        format.json { render json: @user_poll.errors, status: unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_poll
      @user_poll = UserPoll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_poll_params
      params.require(:user_poll).permit(:title, :description, :create_date, :poll_questions_attributes => [:text, :answers_attributes => [:text]])
    end

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

    def can_request_more_news_feed_polls?(num_polls)
      num_polls < UserPoll.where.not(user_id: current_user.id).count
    end

    def can_request_more_current_user_polls?(num_polls)
      num_polls < UserPoll.where(user_id: current_user.id).count
    end
end
