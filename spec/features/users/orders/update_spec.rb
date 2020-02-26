require 'rails_helper'

RSpec.describe 'profile orders show page', type: :feature do
  describe 'As a user' do
    before :each do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      @merchant = create(:random_merchant)

      item1 = create(:random_item, merchant: @merchant, inventory: 100)
      item2 = create(:random_item, merchant: @merchant, inventory: 200)
      item3 = create(:random_item, merchant: @merchant, inventory: 300)

      @order1 = create(:random_order, user: user)
      @order2 = create(:random_order, user: user)
      @semi_fulfilled_order = create(:random_order, user: user)

      @item_order1 = create(:random_item_order, item: item1, order: @order1, price: item1.price, quantity: 3)
      @item_order2 = create(:random_item_order, item: item2, order: @order1, price: item2.price, quantity: 7)

      @item_order3 = create(:random_item_order, item: item3, order: @order2, price: item3.price, quantity: 12)

      create(:random_item_order, item: item1, order: @semi_fulfilled_order, price: item1.price, quantity: 100, status: 1)
      create(:random_item_order, item: item2, order: @semi_fulfilled_order, price: item2.price, quantity: 50, status: 1)
      create(:random_item_order, item: item3, order: @semi_fulfilled_order, price: item3.price, quantity: 25)
    end

    it "I can cancel my order" do
      visit "/profile/orders/#{@order1.id}"

      expect(@order1.status).to eq("pending")

      click_link("Cancel Order")

      expect(current_path).to eq("/profile")
      expect(@item_order1.status).to eq("unfulfilled")
      expect(@item_order2.status).to eq("unfulfilled")
      expect(@merchant.items.first.inventory).to eq(100)
      expect(@merchant.items.second.inventory).to eq(200)
      expect(page).to have_content("Order cancelled")

      visit "/profile/orders"

      within("#order-#{@order1.id}") { expect(page).to have_content("Status: cancelled") }
     end

    it "fulfilled items are restocked when I cancel my order" do
      visit "/profile/orders/#{@semi_fulfilled_order.id}"

      expect(@semi_fulfilled_order.status).to eq("pending")

      click_link("Cancel Order")

      expect(current_path).to eq("/profile")
      @semi_fulfilled_order.item_orders.each do |item_order|
        expect(item_order.status).to eq("unfulfilled")
      end
      expect(@merchant.items.first.inventory).to eq(200)
      expect(@merchant.items.second.inventory).to eq(250)
      expect(@merchant.items.third.inventory).to eq(300)
      expect(page).to have_content("Order cancelled")

      visit "/profile/orders"

      within("#order-#{@semi_fulfilled_order.id}") { expect(page).to have_content("Status: cancelled") }
     end

    it "I can't see the link to cancel a shipped order" do
      @semi_fulfilled_order.item_orders.last.update(status: 'fulfilled')
      @semi_fulfilled_order.update(status: "shipped")

      visit "/profile/orders/#{@semi_fulfilled_order.id}"
      expect(page).to_not have_link("Cancel Order")

      visit "/profile/orders"

      within("#order-#{@semi_fulfilled_order.id}") { expect(page).to have_content("Status: shipped") }
     end

    it "I can't cancel a shipped order" do
      @semi_fulfilled_order.item_orders.last.update(status: 'fulfilled')
      visit "/profile/orders/#{@semi_fulfilled_order.id}"
      @semi_fulfilled_order.update(status: "shipped")

      click_link("Cancel Order")

      expect(current_path).to eq("/profile")

      expect(@merchant.items.first.inventory).to eq(100)
      expect(@merchant.items.second.inventory).to eq(200)
      expect(@merchant.items.third.inventory).to eq(300)
      expect(page).to have_content("Unable to cancel an order that is already")

      visit "/profile/orders"

      within("#order-#{@semi_fulfilled_order.id}") { expect(page).to have_content("Status: shipped") }
     end

  end
end
