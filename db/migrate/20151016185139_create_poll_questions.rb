class CreatePollQuestions < ActiveRecord::Migration
  def change
    create_table :poll_questions do |t|
      t.text :text
      t.references :user_poll, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
