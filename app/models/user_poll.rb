class UserPoll < ActiveRecord::Base
  has_many(:poll_options, dependent: :destroy)
  belongs_to(:user)
  accepts_nested_attributes_for(:poll_options)

  @@MAX_POLL_OPTIONS = 10

  def self.MAX_POLL_OPTIONS
    @@MAX_POLL_OPTIONS
  end
end
