require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it {should define_enum_for(:status).with_values([:packaged, :pending, :shipped, :cancelled])}
  end

  describe "relationships" do
    it {should belong_to :user}
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: create(:regular_user))

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end

    it "item_count" do
      expect(@order_1.item_count).to eq(5)
    end

    it "cancel" do
      @order_1.item_orders.second.update(status: "fulfilled")
      @order_1.cancel

      expect(@order_1.status).to eq("cancelled")
      expect(@order_1.item_orders.second.status).to eq("unfulfilled")
      expect(Item.first.inventory).to eq(12)
      expect(Item.last.inventory).to eq(35)
    end

    it 'ready' do
      expect(@order_1.status).to eq('pending')

      @order_1.item_orders.each do |item|
        item.update(status: 'fulfilled')
      end

      expect(@order_1.item_orders.first.status).to eq('fulfilled')
      expect(@order_1.item_orders.last.status).to eq('fulfilled')
      expect(@order_1.status).to eq('pending')

      @order_1.ready

      expect(@order_1.status).to eq('packaged')
    end

    it 'show_cancel' do
      expect(@order_1.status).to eq('pending')
      expect(@order_1.show_cancel).to eq(true)

      @order_1.item_orders.each do |item|
        item.update(status: 'fulfilled')
      end

      expect(@order_1.item_orders.first.status).to eq('fulfilled')
      expect(@order_1.item_orders.last.status).to eq('fulfilled')
      expect(@order_1.status).to eq('pending')
      expect(@order_1.show_cancel).to eq(true)

      @order_1.ready

      expect(@order_1.status).to eq('packaged')
      expect(@order_1.show_cancel).to eq(true)

      @order_1.update(status: 'shipped')

      expect(@order_1.show_cancel).to eq(false)

      @order_1.update(status: 'cancelled')

      expect(@order_1.show_cancel).to eq(false)
    end
  end

  describe 'model class methods' do
    it 'order by status' do
      order1 = create(:random_order)
      order2 = create(:random_order, status: "cancelled")
      order3 = create(:random_order, status: "packaged")
      order4 = create(:random_order, status: "packaged")
      order5 = create(:random_order, status: "shipped")
      sorted_orders = Order.by_status
      expect(sorted_orders).to eq([order3, order4, order1, order5, order2])
    end
  end
end
