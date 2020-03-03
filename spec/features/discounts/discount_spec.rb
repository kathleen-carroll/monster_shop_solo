require 'rails_helper'

RSpec.describe "checkout discounts page" do
  describe "When I visit the cart checkout page" do
    before(:each) do
      @item1 = create(:random_item, price: 55.50)
      @item2 = create(:random_item, merchant: @item1.merchant, price: 66.78)
      @discount = create(:discount, merchant: @item1.merchant, item_count: 20, percent: 5)
      @discount2 = create(:discount, merchant: @item1.merchant, item_count: 25, percent: 10)
      @discount3 = create(:discount)
      contents = {@item1.id.to_s => 1, @item2.id.to_s => 1}
      @cart = Cart.new(contents)
      # @cart = Cart.new(session[:cart])

      visit "/items/#{@item1.id}"
      click_on "Add To Cart"
      visit "/items/#{@item2.id}"
      click_on "Add To Cart"

      visit '/cart'

      within ("#cart-item-#{@item2.id}") do
        20.times do click_on "+" end
      end
    end

    it 'can see discounts available for items from a merchant' do
      visit '/cart'

      expect(page).to have_content("#{@discount.percent}% off when you purchase #{@discount.item_count} of the same item from #{@discount.merchant.name}")
      expect(page).to have_content("#{@discount2.percent}% off when you purchase #{@discount2.item_count} of the same item from #{@discount2.merchant.name}")
      expect(page).to_not have_content("#{@discount3.percent}% off when you purchase #{@discount3.item_count} of the same item from #{@discount3.merchant.name}")
    end

    it 'sees price change from lower discount applied' do
      visit '/cart'

      within("#cart-item-#{@item2.id}") do
        expect(page).to have_content("$#{@item2.price}")
        expect(page).to_not have_content("$1,402.38") # price * 21
        discount_val = (@item2.price * 21) * 0.95 # 1332.26
        expect(page).to have_content("$1,332.26")
      end

      expect(page).to have_content("Total: $1,387.76")
    end

    it 'sees price change from higher discount applied' do
      visit '/cart'

      within("#cart-item-#{@item2.id}") do
        5.times do click_on "+" end
        discount_val2 = (@item2.price * 26) * 0.90
        expect(page).to have_content("$1,562.65")
      end
      # total = @item1.price + discount_val2
      expect(page).to have_content("Total: $1,618.15")
    end
  end
end
