class CommentsController < ApplicationController
    def create 
        @user_poll = UserPoll.find(params[:user_poll_id])
        @comment = @user_poll.comments.create(comment_param)
        redirect_to user_poll_path(@user_poll)
    end
    
    private 
        def comment_param
            params.require(:comment).permit(:commenter, :body)
        end
end
