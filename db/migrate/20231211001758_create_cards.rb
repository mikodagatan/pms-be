class CreateCards < ActiveRecord::Migration[7.1]
  def change
    create_table :cards do |t|
      t.references :column, null: false, foreign_key: true, index: true
      t.string :name
      t.string :code
      t.text :description
      t.integer :priority
      t.integer :position
      t.references :requester, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
  end
end
