class Result < ActiveRecord::Base
  belongs_to :answer
  validates :number, presence: true
end
