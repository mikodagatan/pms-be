class AddActionStatusToCardHistory < ActiveRecord::Migration[7.1]
  def change
    add_column :card_histories, :action_status, :integer, default: 0
  end
end
