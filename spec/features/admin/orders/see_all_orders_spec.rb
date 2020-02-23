require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  describe 'When I visit my admin dashboard' do
    it 'I see all orders and their information currently in the system' do

      user = create(:admin_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      item_order1 = create(:random_item_order)
      item_order2 = create(:random_item_order)
      item_order2.order.update(status: 1)
      item_order3 = create(:random_item_order)
      item_order3.order.update(status: 2)
      item_order4 = create(:random_item_order)
      item_order4.order.update(status: 3)
      item_order5 = create(:random_item_order)

      visit '/admin'

      expect(page).to have_link(item_order1.order.name)
      expect(page).to have_content(item_order1.order.id)
      expect(page).to have_content(item_order1.order.status)
      expect(page).to have_content(item_order1.order.created_at.to_formatted_s(:long))

      expect(page).to have_link(item_order2.order.name)
      expect(page).to have_content(item_order2.order.id)
      expect(page).to have_content(item_order2.order.status)
      expect(page).to have_content(item_order2.order.created_at.to_formatted_s(:long))

      expect(page).to have_link(item_order3.order.name)
      expect(page).to have_content(item_order3.order.id)
      expect(page).to have_content(item_order3.order.status)
      expect(page).to have_content(item_order3.order.created_at.to_formatted_s(:long))

      expect(page).to have_link(item_order4.order.name)
      expect(page).to have_content(item_order4.order.id)
      expect(page).to have_content(item_order4.order.status)
      expect(page).to have_content(item_order4.order.created_at.to_formatted_s(:long))

      expect(page).to have_link(item_order5.order.name)
      expect(page).to have_content(item_order5.order.id)
      expect(page).to have_content(item_order5.order.status)
      expect(page).to have_content(item_order5.order.created_at.to_formatted_s(:long))
    end
  end
end
