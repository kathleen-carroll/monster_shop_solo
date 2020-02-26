require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  describe 'I can view an active order show page for any user' do
    it 'And cancel that order' do

      admin_user = create(:admin_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

      user1 = create(:regular_user)
      order1 = create(:random_order, user: user1)
      item_order1 = create(:random_item_order, order: order1)

      visit "/admin/users/#{user1.id}/orders/#{order1.id}"

      expect(page).to have_content("Order ID: #{order1.id}")
      expect(page).to have_content('Status: pending')
      expect(page).to have_content("Ordered on: #{order1.created_at.to_formatted_s(:long)}")
      expect(page).to have_content("Total number of items: #{order1.item_count}")
      expect(page).to have_content("#{order1.name}")
      expect(page).to have_link('Cancel Order')

      click_link 'Cancel Order'

      expect(page).to have_content('Order cancelled')

      expect(current_path).to eq(admin_path)

      within("#order_#{order1.id}") do
        expect(page).to have_content('cancelled')
      end

      expect(order1.reload.status).to eq('cancelled')
    end
  end
end
