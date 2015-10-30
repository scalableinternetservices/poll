class Answer < ActiveRecord::Base
  belongs_to :poll_question
  
  has_many :results, dependent: :destroy
  accepts_nested_attributes_for :results

  validates :text, presence: true

end