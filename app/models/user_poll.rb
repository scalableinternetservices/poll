class UserPoll < ActiveRecord::Base
  has_many(:poll_options, dependent: :destroy)
  belongs_to(:user)
  accepts_nested_attributes_for(:poll_options)
end
