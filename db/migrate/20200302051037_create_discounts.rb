class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :percent
      t.integer :item_count

      t.timestamps
    end
  end
end
