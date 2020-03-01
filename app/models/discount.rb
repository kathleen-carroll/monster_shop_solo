class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name,
                        :item_count,
                        :percent
end
