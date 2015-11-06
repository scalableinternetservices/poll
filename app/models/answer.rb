class Answer < ActiveRecord::Base
  belongs_to :poll_question
  
  has_many :results, dependent: :destroy
  accepts_nested_attributes_for :results

  validates :text, presence: true
  
  def create_result
    Result.create(:answer_id => self.id, :votes => 1)
  end
end