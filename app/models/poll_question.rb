class PollQuestion < ActiveRecord::Base
  belongs_to :user_poll
  has_many :answers
  accepts_nested_attributes_for  :answers

  @@MAX_NUM_ANSWERS = 4

  def self.MAX_NUM_ANSWERS
    @@MAX_NUM_ANSWERS
  end
end
