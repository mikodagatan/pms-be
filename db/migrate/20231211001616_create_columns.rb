class CreateColumns < ActiveRecord::Migration[7.1]
  def change
    create_table :columns do |t|
      t.references :project, null: false, foreign_key: true, index: true
      t.string :name
      t.integer :position

      t.timestamps
    end
  end
end
