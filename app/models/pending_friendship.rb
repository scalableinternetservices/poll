class PendingFriendship < ActiveRecord::Base
  belongs_to :requestor, class_name: "User", foreign_key: :user_id
  belongs_to :receiver, class_name: "User", foreign_key: :user_id
end
