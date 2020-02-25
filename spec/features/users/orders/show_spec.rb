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
      @item_order3 = create(:random_item_order, item: item3, order: @order2, price: item3.price, quantity: 12)

      visit "/profile/orders"
    end

    it "I can see the information for my order" do
      expected_date = @order1.created_at.to_formatted_s(:long)
      click_link(@order1.id.to_s)

      expect(current_path).to eq("/profile/orders/#{@order1.id}")
      expect(page).to have_content(@order1.id)
      expect(page).to have_content(expected_date)
      expect(page).to have_content(expected_date)
      expect(page).to have_content(@order1.status)
      expect(page).to have_content("Total number of items: #{@order1.item_count}")
      expect(page).to have_content(@order1.grandtotal.round(2))
      within("section#item_order-#{@item_order1.id}") do
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item1.description)
        expect(page).to have_css("img[src*='#{@item1.image}']")
        expect(page).to have_content(@item_order1.quantity)
        expect(page).to have_content(@item1.price.round(2))
        expect(page).to have_content(@item_order1.subtotal.round(2))
      end
      expect(page).to have_css("#item_order-#{@item_order2.id}")
      expect(page).to_not have_css("#item_order-#{@item_order3.id}")
    end

  end
end
