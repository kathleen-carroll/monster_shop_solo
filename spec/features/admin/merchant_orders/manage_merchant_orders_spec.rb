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

  describe "I can click on the merchant's items link" do
    it 'I can add new items' do
      visit admin_merchant_path(@merchant)

      expect(page).to have_content
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
