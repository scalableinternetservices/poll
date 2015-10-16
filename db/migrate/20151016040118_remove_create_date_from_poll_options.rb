class RemoveCreateDateFromPollOptions < ActiveRecord::Migration
  def change
    remove_column :poll_options, :create_date, :datetime
    drop_table :poll_entries
  end
end
