class UserPoll < ActiveRecord::Base
  has_many(:poll_questions, dependent: :destroy)
  belongs_to(:user)
  accepts_nested_attributes_for(:poll_questions)

  @@MAX_NUM_POLL_QUESTIONS = 10

  def self.MAX_NUM_POLL_QUESTIONS
    @@MAX_NUM_POLL_QUESTIONS
  end
end
