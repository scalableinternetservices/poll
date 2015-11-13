class CreateSharedPolls < ActiveRecord::Migration
  def change
    create_table :shared_polls do |t|
      t.references :sharee, index: true, references: :users
      t.references :sharer, index: true, references: :users
      t.references :user_poll, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
