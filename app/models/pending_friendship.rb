class PendingFriendship < ActiveRecord::Base
  belongs_to :requestor_id
  belongs_to :receiver_id
end
