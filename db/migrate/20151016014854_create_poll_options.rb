class CreatePollOptions < ActiveRecord::Migration
  def change
    create_table :poll_options do |t|
      t.references :user_poll, index: true, foreign_key: true
      t.text :text

      t.timestamps null: false
    end
  end
end
