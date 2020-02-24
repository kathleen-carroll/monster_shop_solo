require 'rails_helper'

RSpec.describe 'merchant employee orders show page', type: :feature do
  describe 'As a merchant' do
    before :each do
      user = create(:regular_user)
      @shop = create(:random_merchant)
      @other_shop = create(:random_merchant)

      employee = create(:merchant_user, merchant: @shop)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)

      @item1 = create(:random_item, merchant: @shop)
      @item2 = create(:random_item, merchant: @shop)
      @item3 = create(:random_item, merchant: @other_shop)

      @order1 = create(:random_order, user: user)
      @order2 = create(:random_order, user: user)

      @item_order1 = create(:random_item_order, item: @item1, order: @order1, price: @item1.price, quantity: 3)
      @item_order2 = create(:random_item_order, item: @item2, order: @order1, price: @item2.price, quantity: 7)
      @item_order3 = create(:random_item_order, item: @item3, order: @order2, price: @item3.price, quantity: 12)

      visit "/merchant/orders/#{@order1.id}"
    end

    it "I can see the order information pertaining to my shop" do
      expect(page).to have_content(@order1.name)
      expect(page).to have_content(@order1.address)
      within("#item-#{@item1.id}") do
        expect(page).to have_link(@item1.name)
        expect(page).to have_css("img[src*='#{@item1.image}']")
        expect(page).to have_content(@item1.price)
        expect(page).to have_content(@item_order1.quantity)
      end
      expect(page).to have_css("#item-#{@item2.id}")
      expect(page).to_not have_css("#item-#{@item3.id}")
    end

  end
end
