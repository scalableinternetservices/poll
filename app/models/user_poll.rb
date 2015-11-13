class UserPoll < ActiveRecord::Base
  @@MIN_NUM_POLL_QUESTIONS = 1
  @@MAX_NUM_POLL_QUESTIONS = 10

  has_many :poll_questions, dependent: :destroy
  has_many :comments, dependent: :destroy
  
  belongs_to :user
  accepts_nested_attributes_for :poll_questions

  validates :title, presence: true
  validates :poll_questions, length: { minimum: @@MIN_NUM_POLL_QUESTIONS }

  # This method associates the attribute ":poll_picture" with a file attachment
  has_attached_file :poll_picture, styles: {
    thumb: '100x100>',
    square: '200x200#'
  }, :default_url => "/images/:style/placeholder-poll.jpg"

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :poll_picture, :content_type => /\Aimage\/.*\Z/

  def self.MAX_NUM_POLL_QUESTIONS
    @@MAX_NUM_POLL_QUESTIONS
  end
end
