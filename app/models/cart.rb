class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    if item.merchant.discounts != [] && !min_discount_qty(item.merchant).nil? && items[item] >= min_discount_qty(item.merchant)
      item.price * @contents[item.id.to_s] * (1 - (discount_subtotal(item).last.percent.to_f/100))
    else
      item.price * @contents[item.id.to_s]
    end
  end

  def min_discount_qty(merchant)
    Discount.joins(:merchant)
      .where("discounts.merchant_id = #{merchant.id}")
      .order(:item_count)
      .limit(1)
      .pluck('discounts.item_count')
      .first
  end

  def discount_subtotal(item)
    qty = items[item]
    discount = Discount.joins(:merchant).where("discounts.merchant_id = #{item.merchant.id} and #{qty} >= discounts.item_count")
    # require "pry"; binding.pry
  end

  def total
    @contents.sum do |item_id,quantity|
      item = Item.find(item_id)
      subtotal(item)
      # Item.find(item_id).price * quantity
    end
  end

  def edit_quantity(params)
    item = Item.find(params[:item_id].to_i)
    if params[:value] == "add"
      contents[params[:item_id]] += 1 unless inventory_limit?("max", item)
    elsif params[:value] == "sub"
      contents[params[:item_id]] -= 1
      return 0 if inventory_limit?("min", item)
    end
  end

  def inventory_limit?(level, item)
    if level == "max"
      item.inventory == contents[item.id.to_s]
    elsif level == "min"
      contents[item.id.to_s] == 0
    end
  end

  def merchants
    items.keys.map {|item| item.merchant}
  end

  def discounts
    merchants.map {|merchant| merchant.discounts}.flatten.uniq
  end
end
