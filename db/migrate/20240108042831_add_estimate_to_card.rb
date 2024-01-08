class AddEstimateToCard < ActiveRecord::Migration[7.1]
  def change
    add_column :cards, :estimate, :decimal, precision: 4, scale: 2, default: 0.00
  end
end
