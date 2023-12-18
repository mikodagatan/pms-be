class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :google_photo_url
      t.string :username

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
