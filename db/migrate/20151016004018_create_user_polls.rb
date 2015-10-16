class CreateUserPolls < ActiveRecord::Migration
  def change
    create_table :user_polls do |t|
      t.string :title
      t.text :description
      t.timestamp :create_date

      t.timestamps null: false
    end
  end
end
