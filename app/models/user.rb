class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_polls, dependent: :destroy
  has_many :shared_with_me_polls, class_name: "SharedPoll", foreign_key: :sharee_id, dependent: :destroy
  has_many :shared_with_others_polls, class_name: "SharedPoll", foreign_key: :sharer_id, dependent: :destroy

  has_many :friendships_to, class_name: "Friendship", foreign_key: :user_id, dependent: :destroy
  has_many :friendships_from, class_name: "Friendship", foreign_key: :friend_id, dependent: :destroy

  has_many :pending_friendships_sent, class_name: "PendingFriendship", foreign_key: :requestor_id, dependent: :destroy
  has_many :pending_friendships_received, class_name: "PendingFriendship", foreign_key: :receiver_id, dependent: :destroy

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :profile_picture, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }, :default_url => "/images/:style/placeholder.png"

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/
end
