require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: create(:regular_user))
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end

    it 'restock' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: create(:regular_user))
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, status: "fulfilled")
      item_order_1.restock
      expect(item_order_1.status).to eq("unfulfilled")
      expect(item_order_1.item.inventory).to eq(14)
    end

    it 'fulfill' do
      shop = create(:random_merchant)

      item1 = create(:random_item, merchant: shop, inventory: 20)

      order1 = create(:random_order)
      order2 = create(:random_order)

      item_order1 = create(:random_item_order, item: item1, order: order1, price: item1.price, quantity: 10)
      item_order2 = create(:random_item_order, item: item1, order: order2, price: item1.price, quantity: 15)

      expect(item_order1.status).to eq('unfulfilled')
      expect(item1.inventory).to eq(20)
      item_order1.fulfill
      expect(item_order1.status).to eq('fulfilled')
      expect(item1.inventory).to eq(10)
      item_order2.fulfill
      expect(item_order2.status).to eq('unfulfilled')
      expect(item1.inventory).to eq(10)
    end

    it "can_fulfill?" do
      shop = create(:random_merchant)

      item1 = create(:random_item, merchant: shop, inventory: 20)

      order1 = create(:random_order)
      order2 = create(:random_order)

      item_order1 = create(:random_item_order, item: item1, order: order1, price: item1.price, quantity: 10)
      item_order2 = create(:random_item_order, item: item1, order: order2, price: item1.price, quantity: 25)

      expect(item_order2.can_fulfill?).to eq(false)
      expect(item_order1.can_fulfill?).to eq(true)
    end
  end

  describe 'class methods' do
    it "by_merchant" do
      shop = create(:random_merchant)
      other_shop = create(:random_merchant)

      item1 = create(:random_item, merchant: shop)
      item2 = create(:random_item, merchant: shop)
      item3 = create(:random_item, merchant: other_shop)

      order1 = create(:random_order)

      item_order1 = create(:random_item_order, item: item1, order: order1, price: item1.price, quantity: 3)
      item_order2 = create(:random_item_order, item: item2, order: order1, price: item2.price, quantity: 7)
      item_order3 = create(:random_item_order, item: item3, order: order1, price: item3.price, quantity: 12)

      expect(order1.item_orders.by_merchant(shop.id)).to eq([item_order1, item_order2])
      expect(order1.item_orders.by_merchant(other_shop.id)).to eq([item_order3])
    end

    it "total" do
      shop = create(:random_merchant)
      other_shop = create(:random_merchant)

      item1 = create(:random_item, merchant: shop)
      item2 = create(:random_item, merchant: shop)
      item3 = create(:random_item, merchant: other_shop)

      order1 = create(:random_order)

      create(:random_item_order, item: item1, order: order1, price: item1.price, quantity: 3)
      create(:random_item_order, item: item2, order: order1, price: item2.price, quantity: 7)
      create(:random_item_order, item: item3, order: order1, price: item3.price, quantity: 12)

      expect(order1.item_orders.total).to eq((item1.price * 3)+(item2.price * 7)+(item3.price * 12))
    end

    it "item_count" do
      shop = create(:random_merchant)
      other_shop = create(:random_merchant)

      item1 = create(:random_item, merchant: shop)
      item2 = create(:random_item, merchant: shop)
      item3 = create(:random_item, merchant: other_shop)

      order1 = create(:random_order)

      create(:random_item_order, item: item1, order: order1, price: item1.price, quantity: 3)
      create(:random_item_order, item: item2, order: order1, price: item2.price, quantity: 7)
      create(:random_item_order, item: item3, order: order1, price: item3.price, quantity: 12)

      expect(order1.item_orders.item_count).to eq(22)
    end
  end

end
