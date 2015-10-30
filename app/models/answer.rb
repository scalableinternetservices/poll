class Answer < ActiveRecord::Base
  belongs_to :poll_question
  @@MAX_NUM_RESULTS = 1

  has_many :result, dependent: :destroy
  accepts_nested_attributes_for  :result
  
  validates :text, presence: true
  validates :result, length: { maximum: @@MAX_NUM_RESULTS }

  def self.MAX_NUM_RESULTS
    @@MAX_NUM_RESULTS
  end
end
