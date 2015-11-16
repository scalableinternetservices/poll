class CommentsController < ApplicationController
    def create 
        @user_poll = UserPoll.find(params[:user_poll_id])
        @comment = @user_poll.comments.create(comment_param)
        @comment.commenter = "#{current_user.first_name} #{current_user.last_name}"
        @comment.save
        redirect_to user_poll_path(@user_poll)
    end
    
    private 
        def comment_param
            params.require(:comment).permit(:commenter, :body)
        end
end
