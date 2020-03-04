class Discount < ApplicationRecord
  belongs_to :merchant
  has_many :item_orders

  validates_presence_of :name, :percent, :item_count
end
