class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_polls, dependent: :destroy

  has_many :friendships_to, class_name: "Friendship", foreign_key: :user_id, dependent: :destroy
  has_many :friendships_from, class_name: "Friendship", foreign_key: :friend_id, dependent: :destroy

  has_many :pending_friendships_sent, class_name: "PendingFriendship", foreign_key: :requestor_id, dependent: :destroy
  has_many :pending_friendships_received, class_name: "PendingFriendship", foreign_key: :receiver_id, dependent: :destroy
end
