class AddMerchantToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_reference :coupons, :merchant, foreign_key: true
  end
end
