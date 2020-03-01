class Coupon < ApplicationRecord
  validates_presence_of :percent_off
  validates :name, uniqueness: true, presence: true, case_sensitive: false
  validates :code, uniqueness: true, presence: true, case_sensitive: false

  belongs_to :merchant
end
