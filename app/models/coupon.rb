class Coupon < ApplicationRecord
  validates_presence_of :name, :code, :percent_off

  belongs_to :merchant
end
