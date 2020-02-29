class AddDiscountsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.integer :threshold
      t.integer :percent
      t.timestamps
      t.references :merchant, foreign_key: true
    end
  end
end
