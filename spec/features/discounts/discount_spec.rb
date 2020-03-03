require 'rails_helper'

RSpec.describe "checkout discounts page" do
  describe "When I visit the cart checkout page" do
    before(:each) do
      @item1 = create(:random_item)
      @item2 = create(:random_item, merchant: @item1.merchant)
      @discount = create(:discount, merchant: @item1.merchant)
      @discount2 = create(:discount, merchant: @item1.merchant)
      @discount3 = create(:discount)

      visit "/items/#{@item1.id}"
      click_on "Add To Cart"
      visit "/items/#{@item2.id}"
      click_on "Add To Cart"
      # 20.times do
    end

    it 'can see discounts available for items from a merchant' do
      visit '/cart'

      expect(page).to have_content("#{@discount.percent}% off when you purchase #{@discount.item_count} of the same item from #{@discount.merchant.name}")
      expect(page).to have_content("#{@discount2.percent}% off when you purchase #{@discount2.item_count} of the same item from #{@discount2.merchant.name}")
      expect(page).to_not have_content("#{@discount3.percent}% off when you purchase #{@discount3.item_count} of the same item from #{@discount3.merchant.name}")
    end
  end
end
