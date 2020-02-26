require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  describe 'When I visit the admin dashboard the order id is a link' do
    it 'I click the link to visit an admin only view of the user order show page' do
      admin_user = create(:admin_user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

      item_order1 = create(:random_item_order)
      order1 = item_order1.order
      user1 = order1.user

      item_order2 = create(:random_item_order)
      order2 = item_order2.order
      user2 = order2.user

      visit admin_path

      within("#order_#{order1.id}") do
        expect(page).to have_link("#{user1.name}")
        expect(page).to have_link("#{order1.id}")
        click_link "#{order1.id}"
      end

      expect(current_path).to eq("/admin/users/#{user1.id}/orders/#{order1.id}")

      expect(page).to have_content("Order ID: #{order1.id}")
      expect(page).to have_content("Ordered on: #{order2.created_at.to_formatted_s(:long)}")
      expect(page).to have_content("Total number of items: #{order1.item_count}")
      expect(page).to have_content("#{order1.name}")

      visit admin_path

      within("#order_#{order2.id}") do
        expect(page).to have_link("#{user2.name}")
        expect(page).to have_link("#{order2.id}")
        click_link "#{order2.id}"
      end

      expect(current_path).to eq("/admin/users/#{user2.id}/orders/#{order2.id}")

      expect(page).to have_content("Order ID: #{order2.id}")
      expect(page).to have_content("Ordered on: #{order2.created_at.to_formatted_s(:long)}")
      expect(page).to have_content("Total number of items: #{order2.item_count}")
      expect(page).to have_content("#{order2.name}")
    end
  end
end
