require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  describe 'when all items on an order are fulfilled' do
    before :each do

      @merchant1 = create(:random_merchant)
      @merchant2 = create(:random_merchant)

      @merchant_user = create(:merchant_user, merchant: @merchant1)
      @user = create(:regular_user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @order1 = create(:random_order, user: @user)

      @item1 = create(:random_item, merchant: @merchant1, inventory: 1000)
      @item2 = create(:random_item, merchant: @merchant2)
      @item3 = create(:random_item, merchant: @merchant2)

      @item_order1 = create(:random_item_order, order: @order1, item: @item1, price: @item1.price)
      @item_order2 = create(:random_item_order, order: @order1, item: @item2, price: @item2.price)
      @item_order3 = create(:random_item_order, order: @order1, item: @item3, price: @item3.price)
    end

    it 'the order status changes from pending to shipped' do

      visit profile_order_path(@order1)

      expect(page).to have_content(@order1.id)
      expect(page).to have_content('Status: pending')
      expect(page).to have_link('Cancel Order')

      within("section#item_order-#{@item_order1.id}") do
        expect(page).to have_content(@item_order1.quantity)
        expect(page).to have_link(@item_order1.item.name)
      end

      within("section#item_order-#{@item_order2.id}") do
        expect(page).to have_content(@item_order2.quantity)
        expect(page).to have_link(@item_order2.item.name)
      end

      within("section#item_order-#{@item_order3.id}") do
        expect(page).to have_content(@item_order3.quantity)
        expect(page).to have_link(@item_order3.item.name)
      end

      visit profile_order_path(@order1)
      expect(page).to have_content('Status: pending')
      expect(page).to have_link('Cancel Order')
    end

    it 'Merchant fulfills order and status changes to packaged' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

      @item_order2.update({status: 1})
      @item_order3.update({status: 1})

      visit merchant_order_path(@order1)

      within("#item-#{@item_order1.item_id}") do
        click_link 'Fulfill Order'
      end

      expect(page).to have_content('Item has been fulfilled')

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_order_path(@order1)
      expect(page).to have_content('Status: packaged')
    end
  end
end
