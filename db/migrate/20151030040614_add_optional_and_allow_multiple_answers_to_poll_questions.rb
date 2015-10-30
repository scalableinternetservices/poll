class AddOptionalAndAllowMultipleAnswersToPollQuestions < ActiveRecord::Migration
  def change
    add_column :poll_questions, :optional, :boolean
    add_column :poll_questions, :allow_multiple_answers, :boolean
  end
end
