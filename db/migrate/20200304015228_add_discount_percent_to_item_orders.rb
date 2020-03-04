class AddDiscountPercentToItemOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :item_orders, :discount_percent, :integer
  end
end
