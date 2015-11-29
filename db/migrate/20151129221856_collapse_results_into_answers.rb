class CollapseResultsIntoAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :votes, :integer

    Result.all.each { |result|
      Answer.find(result.answer_id).votes = result.votes
    }

    drop_table :results do |t|
      t.integer :votes
      t.references :answer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
