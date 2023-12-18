class CreateCardAssignees < ActiveRecord::Migration[7.1]
  def change
    create_table :card_assignees do |t|
      t.references :card, index: true
      t.references :assignee, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end

    add_index :card_assignees, %i[card_id assignee_id], unique: true
  end
end
