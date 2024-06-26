class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :commenter, null: false, foreign_key: { to_table: :users }, index: true
      t.references :resource, polymorphic: true, null: false, index: true

      t.timestamps
    end
  end
end
