require 'rails_helper'

RSpec.describe 'profile orders index page', type: :feature do
  describe 'As a user' do
    before :each do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      item3 = create(:random_item, price: 10.2424)
      item2 = create(:random_item, price: 100.99)
      item1 = create(:random_item, price: 15.75)

      @order1 = create(:random_order, user: user)
      @order2 = create(:random_order, user: user)

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
      expected_date = @order1.created_at.to_formatted_s(:long)
      visit('/profile/orders')

      within("#order-#{@order1.id}") do
        expect(page).to have_link(@order1.id.to_s)
        expect(page).to have_content("Created: #{expected_date}")
        expect(page).to have_content("Updated: #{expected_date}")
        expect(page).to have_content("Status: #{@order1.status}")
        expect(page).to have_content("Number of items: 10")
        expect(page).to have_content(@order1.grandtotal)
      end
    end
  end
end
