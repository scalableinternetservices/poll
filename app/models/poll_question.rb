class PollQuestion < ActiveRecord::Base
  @@MIN_NUM_ANSWERS = 2
  @@MAX_NUM_ANSWERS = 10

  belongs_to :user_poll
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for  :answers

  validates :text, presence: true
  validates :answers, length: { minimum: @@MIN_NUM_ANSWERS }

  def self.MAX_NUM_ANSWERS
    @@MAX_NUM_ANSWERS
  end
end
