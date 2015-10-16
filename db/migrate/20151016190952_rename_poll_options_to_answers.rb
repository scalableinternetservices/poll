class RenamePollOptionsToAnswers < ActiveRecord::Migration
  def change
    rename_table :poll_options, :answers
  end
end
