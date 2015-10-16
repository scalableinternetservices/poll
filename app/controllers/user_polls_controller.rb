class UserPollsController < ApplicationController
  before_action :set_user_poll, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /user_polls
  # GET /user_polls.json
  def index
    @user_polls = UserPoll.all
  end

  # GET /user_polls/1
  # GET /user_polls/1.json
  def show
  end

  # GET /user_polls/new
  def new
    @user_poll = UserPoll.new
    @max_num_options = UserPoll.MAX_POLL_OPTIONS
    @poll_options = Array.new(4) { PollOption.new }
    @blank_poll_option = PollOption.new
  end

  # GET /user_polls/1/edit
  def edit
    @max_num_options = UserPoll.MAX_POLL_OPTIONS
    @poll_options = @user_poll.poll_options
    @blank_poll_option = PollOption.new
  end

  # POST /user_polls
  # POST /user_polls.json
  def create
    @user_poll = current_user.user_polls.new(user_poll_params)
    poll_option_params.each { |index, poll_option_args| print poll_option_args; @user_poll.poll_options.new(poll_option_args) if poll_option_args[:text] != '' }

    respond_to do |format|
      if @user_poll.save
        format.html { redirect_to @user_poll, notice: 'User poll was successfully created.' }
        format.json { render :show, status: :created, location: @user_poll }
      else
        # TODO: Need to make sure that if one of the saves fails, then both don't occur
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
    @user_poll.destroy
    respond_to do |format|
      format.html { redirect_to user_polls_url, notice: 'User poll was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_poll
      @user_poll = current_user.user_polls.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_poll_params
      params.require(:user_poll).permit(:title, :description, :create_date)
    end

    def poll_option_params
      params.require(:user_poll).permit(:poll_option => [:text]).require(:poll_option)
    end
end
