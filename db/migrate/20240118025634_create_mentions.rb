class CreateMentions < ActiveRecord::Migration[7.1]
  def change
    create_table :mentions do |t|
      t.references :commenter, foreign_key: { to_table: :users }, null: false
      t.references :mentioned, foreign_key: { to_table: :users }, null: false
      t.references :resource, polymorphic: true, null: false
      t.datetime :email_sent_at

      t.timestamps
    end

    add_index :mentions,
              %i[mentioned_id resource_id resource_type],
              unique: true,
              name: 'index_mentions_on_mentioned_and_resource'
  end
end
