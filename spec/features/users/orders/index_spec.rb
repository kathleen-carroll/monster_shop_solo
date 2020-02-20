require 'rails_helper'

RSpec.describe 'profile orders index page', type: :feature do
  describe 'As a user' do
    before :each do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      item3 = create(:random_item)
      item2 = create(:random_item)
      item1 = create(:random_item)

      @order1 = create(:random_order)
      @order2 = create(:random_order)

      create(:random_item_order, item: item1, order: @order1, price: item1.price, quantity: 3)
      create(:random_item_order, item: item2, order: @order1, price: item2.price, quantity: 7)
      create(:random_item_order, item: item3, order: @order2, price: item3.price, quantity: 12)
    end

    it 'I can see a link to my orders' do
      visit '/profile'

      click_link('My Orders')
      expect(current_path).to eq('/profile/orders')
    end

    it "I see a list of my orders" do
      visit('/profile/orders')

      within("#order-#{@order1.id}") do
        expect(page).to have_link(@order1.id)
        expect(page).to have_content("Created: #{@order1.created_at}")
        expect(page).to have_content("Updated: #{@order1.updated_at}")
        expect(page).to have_content("Status: #{@order1.status}")
        expect(page).to have_content("Number of items: #{@order1.items.count}")
        expect(page).to have_content("Grand total: #{@order1.grandtotal}")
      end
    end
  end
end
