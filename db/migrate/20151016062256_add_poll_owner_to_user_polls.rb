class AddPollOwnerToUserPolls < ActiveRecord::Migration
  def change
    add_reference :user_polls, :poll_owner, index: true, foreign_key: true
  end
end
