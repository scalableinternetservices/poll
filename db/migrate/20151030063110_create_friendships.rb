class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :user, index: true, foreign_key: true
      t.references :friend, index: true, references: :users
      t.foreign_key :users, column: :friend_id

      t.timestamps null: false
    end
  end
end
