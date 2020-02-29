require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  before :each do
    @user = create(:admin_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

    @merchant = create(:random_merchant)
    @item1 = create(:random_item, merchant: @merchant)
    @item2 = create(:random_item, merchant: @merchant)
    @item3 = create(:random_item, merchant: @merchant)
    @order1 = create(:random_order)
    @order2 = create(:random_order)
    @order3 = create(:random_order)
    @item_order = create(:random_item_order, order: @order1, item: @item1)
    @item_order = create(:random_item_order, order: @order2, item: @item2)
    @item_order = create(:random_item_order, order: @order3, item: @item3)
  end

  describe "I visit a merchant's dashboard and click link 'My Items'" do
    it 'I see all item details the merchant would see' do
      visit "/admin/merchants/#{@merchant.id}/items"
      save_and_open_page
      within("#item-#{@item1.id}") do
        expect(page).to have_link(@item1.name)
        expect(page).to have_link(@merchant.name)
        expect(page).to have_link('Delete')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Deactivate')
        expect(page).to have_content('Activate')
        expect(page).to have_content(@item1.inventory)
        expect(page).to have_content(@item1.price)
        expect(page).to have_content(@item1.description)
      end

      within("#item-#{@item2.id}") do
        expect(page).to have_link(@item2.name)
        expect(page).to have_link(@merchant.name)
        expect(page).to have_link('Delete')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Deactivate')
        expect(page).to have_content('Activate')
        expect(page).to have_content(@item2.inventory)
        expect(page).to have_content(@item2.price)
        expect(page).to have_content(@item2.description)
      end

      within("#item-#{@item3.id}") do
        expect(page).to have_link(@item3.name)
        expect(page).to have_link(@merchant.name)
        expect(page).to have_link('Delete')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Deactivate')
        expect(page).to have_content('Activate')
        expect(page).to have_content(@item3.inventory)
        expect(page).to have_content(@item3.price)
        expect(page).to have_content(@item3.description)
      end
    end

    it 'I can deactivate and activate items' do
      within("#item-#{@item1.id}") do
        click_link 'Deactivate'
      end

      expect(page).to have_content("#{@item1.name} is no longer for sale.")

      within("#item-#{@item1.id}") do
        click_link 'Activate'
      end

      expect(page).to have_content("#{@item1.name} is available for sale.")
    end

    it 'I can delete items' do

      within("#item-#{@item3.id}") do
        click_link 'Delete'
      end

      expect(page).to have_content("'#{@item1.name}' has been deleted.")
    end

    it 'I can edit items' do

      within("#item-#{@item1.id}") do
        click_link 'Edit'
      end

      expect(current_path).to eq("/admin/merchants/#{@merchant.id}/items/#{@item1.id}/edit")

      within("#name") do
        expect(page).to have_content(@item1.name)
      end

      within("#description") do
        expect(page).to have_content(@item1.description)
      end

      within("#price") do
        expect(page).to have_content(@item1.price)
      end

      within("#image") do
        expect(page).to have_content(@item1.image.to_s)
      end

      within("#inventory") do
        expect(page).to have_content(@item1.inventory)
      end
    end
  end
end

# User Story 61, EXTENSION: Admin can manage items on behalf of a merchant

# As an admin user
# When I visit a merchant's profile page
# I can click on the merchant's items link
# And have access to all functionality the merchant does, including
# - adding new items
# - editing existing items
# - enabling/disabling/deleting items

# All content rules still apply (eg, item name cannot be blank, etc)
