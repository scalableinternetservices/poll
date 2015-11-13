class PollQuestion < ActiveRecord::Base
  @@MIN_NUM_ANSWERS = 2
  @@MAX_NUM_ANSWERS = 10

  belongs_to :user_poll
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for  :answers

  validates :text, presence: true
  validates :answers, length: { minimum: @@MIN_NUM_ANSWERS }

  # This method associates the attribute ":poll_picture" with a file attachment
  has_attached_file :poll_question_picture, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }, :default_url => "/images/:style/placeholder-poll.jpg"

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :poll_question_picture, :content_type => /\Aimage\/.*\Z/

  def self.MAX_NUM_ANSWERS
    @@MAX_NUM_ANSWERS
  end
end
