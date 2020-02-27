require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  describe 'When I visit a users admin showpage' do
    before :each do
      user = create(:admin_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      item_order1 = create(:random_item_order)
      @order = item_order1.order
      @user = item_order1.order.user
      @order2 = create(:random_order, user: @user)
      item_order2 = create(:random_item_order, order: @order2)
    end

    it 'I click My Orders and see all active orders for that user' do

      visit "/admin/users/#{@user.id}"

      click_link 'My Orders'

      expect(page).to have_content("Order##{@order.id}")
      expect(page).to have_content("Status: #{@order.status}")
      expect(page).to have_content("Number of items: #{@order.item_count}")

      expect(page).to have_content("Order##{@order2.id}")
      expect(page).to have_content("Status: #{@order2.status}")
      expect(page).to have_content("Number of items: #{@order2.item_count}")
    end
  end
end
