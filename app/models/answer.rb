class Answer < ActiveRecord::Base
  belongs_to :poll_question

  has_many :result, dependent: :destroy
  accepts_nested_attributes_for  :result
  
  validates :text, presence: true
  validates :result, length: { maximum: 1 }

end
