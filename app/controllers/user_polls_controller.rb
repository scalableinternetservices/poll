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
    poll_id = poll_details_params
    votes = UserVote.where(user_poll_id: poll_id.to_i).order(:created_at)

    if votes.count == 0
      render json: {}
    else
      # First determine the time range
      time_range_start = votes[0].created_at.to_i
      time_range_end = votes[-1].created_at.to_i

      num_bins = 10
      time_scale = (time_range_end - time_range_start) / num_bins

      if time_scale == 0.0
        vote_counts = [votes.count]
      else
        vote_counts = Array.new(num_bins) { 0 }

        votes.each { |vote|
          index = ((vote.created_at.to_i - time_range_start) / time_scale).floor
          index = [[index, 0].max, num_bins - 1].min
          vote_counts[index] += 1
        }
      end
        
      render json: { time_range: [time_range_start, time_range_end], vote_counts: vote_counts }
    end
  end

  # GET /user_polls/1/question_details.json
  def question_details
    question_id = question_details_params
    question = PollQuestion.find(question_id.to_i)

    answer_texts = question.answers.map { |answer| answer.text }
    vote_counts = question.answers.map { |answer| answer.votes }

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
        format.html { redirect_to user_poll_results_path(@user_poll), notice: 'User poll was successfully created.' }
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
        format.html { redirect_to root_path, notice: 'User poll was successfully destroyed.' }
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
        format.html { redirect_to root_path, notice: 'Successfully shared poll' }
      else
        format.html { redirect_to root_path, notice: 'Failed to share poll' }
      end
    end
  end

  # GET /user_polls/:id/vote
  def vote
    @user_poll = UserPoll.find(vote_params[:id])

    if UserVote.exists?(user_id: current_user.id, user_poll_id: @user_poll.id)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'You already voted on this poll!' }
      end
    end
  end

  # POST /user_polls/submit_vote
  def submit_vote
    invalid = false

    print params.key?(:answers)
    answers = params.key?(:answers) ? params[:answers] : Hash.new

    # Count the number of answers for each seen question, so that the input can be validated
    # before changing the model.
    answer_count = Hash.new
    answers.each { |index, answer_id|
      question_id = Answer.find(answer_id).poll_question_id.to_i
      if answer_count.key?(question_id)
        answer_count[question_id] += 1
      else
        answer_count[question_id] = 1
      end
    }

    # Validate that the that the questions belongs to the right poll
    answer_count.each { |question_id, count|
      if PollQuestion.find(question_id).user_poll_id != params[:poll_id].to_i
        invalid = true
        break
      end
    }
    
    # Check that the number of answers follows the necessary constraints
    @user_poll = UserPoll.find(params[:poll_id])
    @user_poll.poll_questions.each { |question|
      print answer_count[question.id]
      if answer_count.key?(question.id) == false
        unless question.optional
          invalid = true
          break
        end
      elsif answer_count[question.id] > 1
        unless question.allow_multiple_answers
          invalid = true
          break
        end
      end
    }

    already_voted_on = UserVote.exists?(user_id: current_user.id, user_poll_id: @user_poll.id)

    unless invalid or already_voted_on
      answers.each { |question_id, answer_id|
        answer = Answer.find(answer_id)
        answer.results[0].votes += 1
        answer.save
      }

      UserVote.create(user_id: current_user.id, user_poll_id: @user_poll.id)

      respond_to do |format|
        format.html { redirect_to finished_voting_path(@user_poll.id) }
      end      
    else
      respond_to do |format|
        if invalid
          format.html { redirect_to vote_on_poll_path(@user_poll.id), notice: "Bad submission" }
        else # if already_voted_on
          format.html { redirect_to vote_on_poll_path(@user_poll.id), notice: "You already voted on this poll!" }
        end
      end
    end
  end

  # GET /user_polls/1/done
  def done
    @user_poll = UserPoll.find(params[:id])
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

    def poll_details_params
      params.require(:id)
    end

    def question_details_params
      params.require(:id)
    end

    def share_with_params
      params.permit(:poll_id, :user_id)
    end

    def vote_params
      params.permit(:id)
    end
end
