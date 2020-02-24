class ChangeDataTypeItemOrdersPrice < ActiveRecord::Migration[5.1]
  def change
    change_column :item_orders, :price, :float
  end
end
