class AddConfirmationToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime

    User.all.update_all(confirmed_at: DateTime.current)
  end

  def down
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
  end
end
