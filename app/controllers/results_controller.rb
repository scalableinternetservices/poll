class ResultsController < ApplicationController
    def create 
        
    end
    
    def test 
        answer = Answer.find(params[:id])
        answer.results[0].update_attribute(:votes, answer.results[0].votes + 1)
        redirect_to root_path
    end
end