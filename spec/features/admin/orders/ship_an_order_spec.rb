require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  describe 'When I log into my dashboard and see orders ready to ship' do
    it "I can click a button to change the order status to shipped" do

      user = create(:admin_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      item_order1 = create(:random_item_order)
      order = item_order1.order
      item_order2 = create(:random_item_order)
      order1 = item_order2.order
      order1.update(status: 0)
      item_order3 = create(:random_item_order)
      order2 = item_order3.order
      order2.update(status: 0)

      visit '/admin'

      within("div#order_#{order.id}") do
        expect(page).to_not have_button('Ship Order')
      end

      within("div#order_#{order1.id}") do
        expect(page).to have_link('Ship Order')
        expect(page).to have_content('packaged')
        click_link 'Ship Order'
        visit '/admin'
        expect(page).to have_content('shipped')
      end

      within("div#order_#{order2.id}") do
        expect(page).to have_link('Ship Order')
        expect(page).to have_content('packaged')
        click_link 'Ship Order'
        visit '/admin'
        expect(page).to have_content('shipped')
      end

    end
  end

  describe 'After an order ships' do
    it 'the user can longer cancel it' do
      item_order2 = create(:random_item_order)
      order1 = item_order2.order
      order1.update(status: 2)
      user1 = order1.user
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)

      visit "/profile/orders/#{order1.id}"

      expect(page).to_not have_content('Cancel Order')
    end
  end
end
