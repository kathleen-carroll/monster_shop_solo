require 'rails_helper'

RSpec.describe "discounts page" do
    before(:each) do
      @item1 = create(:random_item)
      @item2 = create(:random_item, merchant: @item1.merchant)
      @discount = create(:discount, merchant: @item1.merchant)
      @discount2 = create(:discount, merchant: @item1.merchant)
      @discount3 = create(:discount)
      @user = create(:merchant_user, merchant: @item1.merchant)
    end

    it 'can create new discount from index page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/merchant/discounts"

      click_on 'New Discount'

      expect(current_path).to eq("/merchant/discounts/new")

      fill_in :name, with: "March Special"
      fill_in :percent, with: 10
      fill_in :item_count, with: 15

      click_button "Create Discount"
      expect(current_path).to eq("/merchant/discounts")

      expect(page).to have_content("March Special has been created.")

      click_on 'New Discount'

      fill_in :name, with: ""
      fill_in :percent, with: 10
      fill_in :item_count, with: 10

      click_button "Create Discount"

      expect(page).to have_content("Name can't be blank")

      fill_in :name, with: "Special"
      fill_in :percent, with: 10
      fill_in :item_count, with: ''

      click_button "Create Discount"

      expect(page).to have_content("Item count can't be blank")
    end
end
