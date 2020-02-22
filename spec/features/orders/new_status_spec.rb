require 'rails_helper'

RSpec.describe 'new order changes status' do
  describe 'from the cart' do
    it 'checkout to create a new order with pending status and removed from cart' do
      item1 = create(:random_item, inventory: 4)

      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/items/#{item1.id}"
      click_on "Add To Cart"
      visit '/cart'
      click_on 'Checkout'

      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_on 'Create Order'

      order = Order.last

      expect(current_path).to eq('/profile/orders')
      expect(page).to have_content('Your order was created.')
      expect(page).to have_content("Order##{order.id}")
      expect(page).to have_content("Cart: 0")

      visit "orders/#{order.id}"

      expect(page).to have_content("Status: pending")
    end
  end
end
