class ResultsController < ApplicationController
    def create 
        
    end
    
    def test 
        answer = Answer.find(params[:id])
        answer.update_attribute(:votes, answer.votes + 1)
        redirect_to root_path
    end
end
