class AddPollPicturesToUserPolls < ActiveRecord::Migration
  def self.up
    add_attachment :user_polls, :poll_picture
  end

  def self.down
    remove_attachment :user_polls, :poll_picture
  end
end
