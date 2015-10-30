class ResultsController < ApplicationController
    def create 
        @Answer = Answer.find(params[:answer_id])
        @result = @Answer.results.create(result_param)
        redirect_to answer_path(@Answer)
    end
    
    private 
        def result_param
            params.require(:result).permit(:votes)
        end
end
