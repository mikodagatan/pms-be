class CreateOpenaiThreads < ActiveRecord::Migration[7.1]
  def change
    create_table :openai_threads do |t|
      t.references :project, null: false, foreign_key: true
      t.string :thread_id

      t.timestamps
    end
  end
end
