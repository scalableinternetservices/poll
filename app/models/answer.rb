class Answer < ActiveRecord::Base
  belongs_to :poll_question

  validates :text, presence: true
end
