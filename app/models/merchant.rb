class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
<<<<<<< HEAD
    item_orders.joins(:order).order('orders.city asc').distinct.pluck('orders.city')
=======
    item_orders.joins(:order).distinct.pluck('orders.city').sort
>>>>>>> becde9cf7e25bf07c04c2a5252cf67d90b3f1ad1
  end

end
