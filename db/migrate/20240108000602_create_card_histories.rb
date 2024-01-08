class CreateCardHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :card_histories do |t|
      t.references :card, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.integer :action
      t.string :attr
      t.text :from
      t.text :to
      t.boolean :ai, default: false
      t.text :output

      t.timestamps
    end
  end
end
