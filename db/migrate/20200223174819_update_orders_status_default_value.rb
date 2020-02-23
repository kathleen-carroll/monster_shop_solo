class UpdateOrdersStatusDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column_default :orders, :status, from: 0, to: 1
  end
end
