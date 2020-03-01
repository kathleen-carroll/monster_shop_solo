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
end
