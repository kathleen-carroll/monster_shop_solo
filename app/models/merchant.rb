class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :orders, through: :item_orders
  has_many :users
<<<<<<< HEAD
  has_many :coupons
=======
  has_many :discounts
>>>>>>> a9c1e152e36e8c83a37b2bad6ed8e549753b03c0

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
    item_orders.joins(:order).order('orders.city asc').distinct.pluck('orders.city')
  end

  def active_items
    items.where(active?: true).order(:id)
  end

  def pending_orders
    orders.where("orders.status = 1").distinct
  end

end
