class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity
  enum status: %w(unfulfilled fulfilled)

  belongs_to :item
  belongs_to :order

  def subtotal
    price * quantity
  end

  def restock
    unless status == "unfulfilled"
      item.increment!(:inventory, quantity)
      update(status: "unfulfilled")
    end
  end
end
