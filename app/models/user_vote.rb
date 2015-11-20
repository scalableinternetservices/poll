class UserVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_poll
end
