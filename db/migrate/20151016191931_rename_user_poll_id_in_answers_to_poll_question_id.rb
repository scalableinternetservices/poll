class RenameUserPollIdInAnswersToPollQuestionId < ActiveRecord::Migration
  def change
    rename_column :answers, :user_poll_id, :poll_question_id
  end
end
