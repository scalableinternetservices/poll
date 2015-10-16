class UserPoll < ActiveRecord::Base
  has_many(:poll_options, dependent: :destroy)
  accepts_nested_attributes_for(:poll_options)
end
