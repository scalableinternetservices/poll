class UserPoll < ActiveRecord::Base
  @@MIN_NUM_POLL_QUESTIONS = 1
  @@MAX_NUM_POLL_QUESTIONS = 10

  has_many :poll_questions, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  belongs_to :user
  accepts_nested_attributes_for :poll_questions

  validates :title, presence: true
  validates :poll_questions, length: { minimum: @@MIN_NUM_POLL_QUESTIONS }

  def self.MAX_NUM_POLL_QUESTIONS
    @@MAX_NUM_POLL_QUESTIONS
  end
end
