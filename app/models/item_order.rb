class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity
  enum status: %w(unfulfilled fulfilled)

  belongs_to :item
  belongs_to :order

  def self.by_merchant(id)
    self
      .all
      .joins(:item)
      .where("items.merchant_id = #{id}")
  end

  def subtotal
    price * quantity
  end

  def restock
    unless status == "unfulfilled"
      item.increment!(:inventory, quantity)
      update(status: "unfulfilled")
    end
  end

  def fulfill
    if can_fulfill?
      item.decrement!(:inventory, quantity)
      update(status: "fulfilled")
    end
  end

  def can_fulfill?
    item.inventory >= quantity
  end
end
