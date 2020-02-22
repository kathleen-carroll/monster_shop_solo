require 'rails_helper'

RSpec.describe 'profile orders show page', type: :feature do
  describe 'As a user' do
    before :each do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      item3 = create(:random_item)
      @item2 = create(:random_item)
      @item1 = create(:random_item)

      @order1 = create(:random_order, user: user)
      @order2 = create(:random_order, user: user)

      @item_order1 = create(:random_item_order, item: @item1, order: @order1, price: @item1.price, quantity: 3)
      @item_order2 = create(:random_item_order, item: @item2, order: @order1, price: @item2.price, quantity: 7)
      create(:random_item_order, item: item3, order: @order2, price: item3.price, quantity: 12)

      visit profile_orders_path
    end

    it "I can see the information for my order" do
      click_link(@order1.id.to_s)
      expect(current_path).to eq(profile_order_path(@order1.id))
      save_and_open_page
      expect(page).to have_content(@order1.id)
      expect(page).to have_content(@order1.created_at)
      expect(page).to have_content(@order1.updated_at)
      expect(page).to have_content(@order1.status)
      within("items") do
        within("#item_order-#{@item_order1.id}") do
          expect(page).to have_content(@item1.name)
          expect(page).to have_content(@item1.description)
          expect(page).to have_content(@item1.image)
          expect(page).to have_content(@item1.quantity)
          expect(page).to have_content(@item1.price)
          expect(page).to have_content(@item_order1.subtotal)
        end
        expect(page).to have_css("#item_order-#{@item_order2.id}")
      end
    end
  end
end
