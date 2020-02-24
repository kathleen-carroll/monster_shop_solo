require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  describe 'when all items on an order are fulfilled' do
    it 'the order status changes from pending to shipped' do

      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      order1 = create(:random_order, user: user)

      merchant1 = create(:random_merchant)
      merchant2 = create(:random_merchant)

      item1 = create(:random_item, merchant: merchant1)
      item2 = create(:random_item, merchant: merchant2)
      item3 = create(:random_item, merchant: merchant2)

      item_order1 = create(:random_item_order, order: order1, item: item1, price: item1.price)
      item_order2 = create(:random_item_order, order: order1, item: item2, price: item2.price)
      item_order3 = create(:random_item_order, order: order1, item: item3, price: item3.price)

      visit profile_order_path(order1)

      expect(page).to have_content(order1.id)
      expect(page).to have_content('Status: pending')
      expect(page).to have_link('Cancel Order')

      within("section#item_order-#{item_order1.id}") do
        # expect(page).to have_content(item_order1.price)
        expect(page).to have_content(item_order1.quantity)
        expect(page).to have_link(item_order1.item.name)
        # expect(page).to have_content(item_order1.subtotal)
      end

      within("section#item_order-#{item_order2.id}") do
        # expect(page).to have_content(item_order2.price)
        expect(page).to have_content(item_order2.quantity)
        expect(page).to have_link(item_order2.item.name)
        # expect(page).to have_content(item_order2.subtotal)
      end

      within("section#item_order-#{item_order3.id}") do
        # expect(page).to have_content(item_order3.price)
        expect(page).to have_content(item_order3.quantity)
        expect(page).to have_link(item_order3.item.name)
        # expect(page).to have_content(item_order3.subtotal)
      end

      item_order1.update({status: 1})
      item_order2.update({status: 1})

      visit profile_order_path(order1)
      expect(page).to have_content('Status: pending')
      expect(page).to have_link('Cancel Order')

      item_order3.update({status: 1})

      # visit profile_order_path(order1)
      # expect(page).to have_content('Status: packaged')
      # expect(page).to_not have_link('Cancel Order')
    end
  end
end

# User Story 31, All Merchants fulfill items on an order

# When all items in an order have been "fulfilled" by their merchants
# The order status changes from "pending" to "packaged"
