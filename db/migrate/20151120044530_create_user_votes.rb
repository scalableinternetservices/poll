class CreateUserVotes < ActiveRecord::Migration
  def change
    create_table :user_votes do |t|
      t.references :user, index: true, foreign_key: true
      t.references :user_poll, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
