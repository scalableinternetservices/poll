class UserPollsController < ApplicationController
  before_action :set_user_poll, only: [:show, :edit, :update, :destroy, :results]
  before_action :authenticate_user!

  # GET /user_polls/1
  # GET /user_polls/1.json
  def show
  end

  # GET /user_polls/1/results
  def results
  end

  # GET /user_polls/1/poll_details.json
  def poll_details
  end

  # GET /user_polls/1/question_details.json
  def question_details
    question_id = question_details_params
    question = PollQuestion.find(question_id)

    answer_texts = question.answers.map { |answer| answer.text }
    vote_counts = question.answers.map { |answer| answer.results[0].votes }

    render json: { answer_texts: answer_texts, vote_counts: vote_counts }
  end

  # GET /user_polls/new
  def new
    @user_poll = UserPoll.new
    @poll_questions = [ PollQuestion.new ]
    @default_num_questions = 1
    @min_num_questions = 1
    @max_num_questions = UserPoll.MAX_NUM_POLL_QUESTIONS
    @default_num_answers = 2
    @min_num_answers = 2
    @max_num_answers = PollQuestion.MAX_NUM_ANSWERS
  end

  # GET /user_polls/1/edit
  def edit
    @poll_questions = @user_poll.poll_questions
    @default_num_questions = 1
    @min_num_questions = 1
    @max_num_questions = UserPoll.MAX_NUM_POLL_QUESTIONS
    @default_num_answers = 2
    @min_num_answers = 2
    @max_num_answers = PollQuestion.MAX_NUM_ANSWERS
  end

  # POST /user_polls
  # POST /user_polls.json
  def create
    # Convert the poll_questions_attributes hash into an array
    cleaned_user_poll_params = user_poll_params
    poll_questions_array = Array.new(user_poll_params[:poll_questions_attributes].length)
    cleaned_user_poll_params[:poll_questions_attributes].each { |index, attributes|
      poll_questions_array[index.to_i] = attributes
    }

    poll_questions_array.each { |question_attributes|
      answers_array = Array.new(question_attributes[:answers_attributes].length)
      question_attributes[:answers_attributes].each { |index, answer_attributes|
        answers_array[index.to_i] = answer_attributes
      }
      question_attributes[:answers_attributes] = answers_array
    }

    # Delete empty fields
    (0...poll_questions_array.length).each { |index|
      poll_questions_array[index][:answers_attributes] = poll_questions_array[index][:answers_attributes].reject { |attributes| attributes[:text] == "" }
    }

    cleaned_user_poll_params[:poll_questions_attributes] = poll_questions_array.reject { |attributes| attributes[:answers_attributes].length == 0 }

    @user_poll = current_user.user_polls.new(cleaned_user_poll_params)

    # Make results for every poll option
    @user_poll.poll_questions.each { |poll_question|
      poll_question.answers.each { |answer|
        result = answer.results.new
        result.votes = 0
      }
    }

    respond_to do |format|
      if @user_poll.save
        format.html { redirect_to @user_poll, notice: 'User poll was successfully created.' }
        format.json { render :show, status: :created, location: @user_poll }
      else
        @poll_questions = @user_poll.poll_questions.length == 0 ? [PollQuestion.new] : @user_poll.poll_questions
        @default_num_questions = 1
        @min_num_questions = 1
        @max_num_questions = UserPoll.MAX_NUM_POLL_QUESTIONS
        @default_num_answers = 2
        @min_num_answers = 2
        @max_num_answers = PollQuestion.MAX_NUM_ANSWERS
        
        format.html { render :new }
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

  # POST /user_polls/1/share_with/2
  def share_with
    cleaned_params = share_with_params
    already_shared_poll = SharedPoll.where(sharee_id: cleaned_params[:user_id], sharer_id: current_user.id, user_poll_id: cleaned_params[:poll_id])

    if already_shared_poll.count > 0
      shared_poll = already_shared_poll[0]
    else
      shared_poll = SharedPoll.new(sharee_id: cleaned_params[:user_id], sharer_id: current_user.id, user_poll_id: cleaned_params[:poll_id])
    end

    respond_to do |format|
      if shared_poll.save
        format.html { redirect_to UserPoll.find(cleaned_params[:poll_id]), notice: 'Successfully shared poll' }
      else
        format.html { redirect_to UserPoll.find(cleaned_params[:poll_id]), notice: 'Failed to share poll' }
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
      params.require(:user_poll).permit(:title, :description, :create_date, :poll_picture, :poll_questions_attributes => [:text, :poll_question_picture, :optional, :allow_multiple_answers, :answers_attributes => [:text]])
    end

    def question_details_params
      params.require(:id)
    end

    def share_with_params
      params.permit(:poll_id, :user_id)
    end
end
