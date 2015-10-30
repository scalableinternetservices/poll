class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :votes
      t.references :answer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
