require 'rails_helper'

describe "instance methods" do
  before(:each) do
    @item1 = create(:random_item, inventory: 4)
    @cart = Cart.new({@item1.id.to_s => 1})
  end

  it 'edit_quantity' do
    params = {item_id: @item1.id.to_s, value: "add"}
    expect(@cart.edit_quantity(params)).to eq(2)

    params = {item_id: @item1.id.to_s, value: "sub"}
    @cart.edit_quantity(params)
    expect(@cart.contents[params[:item_id]]).to eq(1)
    expect(@cart.edit_quantity(params)).to eq(0)
  end

  it 'inventory_limit' do
    expect(@cart.inventory_limit?("max", @item1)).to eq(false)
    @cart.contents[@item1.id.to_s] = 4
    expect(@cart.inventory_limit?("max", @item1)).to eq(true)

    expect(@cart.inventory_limit?("min", @item1)).to eq(false)
    @cart.contents[@item1.id.to_s] = 0
    expect(@cart.inventory_limit?("min", @item1)).to eq(true)
  end

  it 'merchants' do
    item2 = create(:random_item)
    @cart.add_item(item2.id)

    expect(@cart.merchants).to eq([@item1.merchant, item2.merchant])
  end

  it 'discounts' do
    item2 = create(:random_item)
    @cart.add_item(item2.id)

    discount = create(:discount, merchant: @item1.merchant)
    discount2 = create(:discount, merchant: item2.merchant)

    expect(@cart.discounts).to eq([discount, discount2])
  end

  it 'min_discount_qty' do
    item2 = create(:random_item)
    @cart.add_item(item2.id)

    discount = create(:discount, merchant: @item1.merchant, item_count: 10)
    discount2 = create(:discount, merchant: @item1.merchant, item_count: 20)

    expect(@cart.min_discount_qty(@item1.merchant)).to eq(10)
  end

  it 'discount_subtotal' do
    2.times do @cart.add_item(@item1.id) end

    discount = create(:discount, merchant: @item1.merchant, item_count: 2, percent: 50)

    expect(@cart.discount_subtotal(@item1)).to eq([discount])
  end
end
