require 'rails_helper'

RSpec.describe "checkout discounts page" do
  describe "When I visit the cart checkout page" do
    before(:each) do
      @item1 = create(:random_item)
      @item2 = create(:random_item, merchant: @item1.merchant)
      @discount = create(:discount, merchant: @item1.merchant)
      @discount2 = create(:discount, merchant: @item1.merchant)
      @discount3 = create(:discount)
      @user = create(:merchant_user, merchant: @item1.merchant)

      # visit "/items/#{@item1.id}"
      # click_on "Add To Cart"
      # visit "/items/#{@item2.id}"
      # click_on "Add To Cart"
    end

    it 'can see discounts available for items from a merchant' do
      visit '/'
      expect(page).to_not have_link("Manage Discounts")

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/merchant'

      click_on "Manage Discounts"
      expect(current_path).to eq("/merchant/discounts")  #/#{@item1.merchant.id}

      expect(page).to have_content("#{@discount2.name}")
      expect(page).to_not have_content("#{@discount3.name}")
      click_on "#{@discount.name}"
      expect(current_path).to eq("/merchant/discounts/#{@discount.id}")
    end

    it 'can see discount show page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/merchant/discounts/#{@discount.id}"

      expect(page).to have_content("#{@discount.name}")
      expect(page).to have_content("Discount Value: #{@discount.percent}%")
      expect(page).to have_content("Item Minimum: #{@discount.item_count}")
      expect(page).to have_content("Offered by: #{@discount.merchant.name}")
    end
  end
end
