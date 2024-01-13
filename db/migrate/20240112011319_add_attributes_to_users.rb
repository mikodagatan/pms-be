class AddAttributesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime
  end
end
