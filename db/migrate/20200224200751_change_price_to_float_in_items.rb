class ChangePriceToFloatInItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :price, from: integer, to: float
  end
end
