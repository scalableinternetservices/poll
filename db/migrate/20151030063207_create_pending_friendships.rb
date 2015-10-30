class CreatePendingFriendships < ActiveRecord::Migration
  def change
    create_table :pending_friendships do |t|
      t.references :requestor, index: true, references: :users
      t.foreign_key :users, column: :requestor_id
      t.references :receiver, index: true, references: :users
      t.foreign_key :users, column: :receiver_id

      t.timestamps null: false
    end
  end
end
