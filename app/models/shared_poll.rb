class SharedPoll < ActiveRecord::Base
  belongs_to :sharee
  belongs_to :sharer
  belongs_to :user_poll
end
