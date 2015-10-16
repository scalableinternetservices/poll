class FixPollOwnerColumnName < ActiveRecord::Migration
  def change
    rename_column :user_polls, :poll_owner_id, :user_id
  end
end
