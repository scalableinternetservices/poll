class AddAttachmentPollQuestionPictureToPollQuestions < ActiveRecord::Migration
  def self.up
    change_table :poll_questions do |t|
      t.attachment :poll_question_picture
    end
  end

  def self.down
    remove_attachment :poll_questions, :poll_question_picture
  end
end
