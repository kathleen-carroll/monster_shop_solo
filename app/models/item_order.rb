class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity
  enum status: %w(unfulfilled fulfilled)
  validates :discount_percent, presence: true, if: :discounted?

  belongs_to :item
  belongs_to :order

  def self.by_merchant(id)
    self
      .all
      .joins(:item)
      .where("items.merchant_id = #{id}")
  end

  def self.total
    sum("item_orders.quantity * item_orders.price * (1 - CAST(COALESCE(item_orders.discount_percent, 0)/100 as int))")
  end

  def self.item_count
    sum(:quantity)
  end

  def subtotal
    price * quantity * (1 - discount_percent.to_f/100)
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

  def discounted?
    !self.discount_percent.nil?
  end
end
