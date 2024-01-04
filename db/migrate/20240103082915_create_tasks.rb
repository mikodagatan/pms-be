class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.references :card, null: false, foreign_key: true, index: true
      t.string :name
      t.boolean :checked, default: false
      t.integer :position
      t.string :type

      t.timestamps
    end
  end
end
