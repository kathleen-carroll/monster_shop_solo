require 'rails_helper'

RSpec.describe "checkout discounts page" do
    before(:each) do
      @item1 = create(:random_item, price: 55.50, inventory: 40)
      @item2 = create(:random_item, merchant: @item1.merchant, price: 66.78, inventory: 30)
      @item3 = create(:random_item, inventory: 60, price: 5)
      @item4 = create(:random_item, inventory: 50, price: 10)
      @discount = create(:discount, merchant: @item1.merchant, item_count: 20, percent: 5)
      @discount2 = create(:discount, merchant: @item1.merchant, item_count: 25, percent: 10)
      @discount3 = create(:discount, merchant: @item1.merchant, item_count: 30, percent: 20)
      @discount4 = create(:discount, merchant: @item4.merchant, item_count: 5, percent: 7)
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
      expect(page).to_not have_content("#{@discount4.percent}% off when you purchase #{@discount4.item_count} of the same item from #{@discount4.merchant.name}")
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

    it 'cant add other merchants discounts' do
      visit "/items/#{@item3.id}"
      click_on "Add To Cart"

      visit '/cart'

      within("#cart-item-#{@item3.id}") do
        20.times do click_on "+" end

        expect(page).to have_content("$105")
        expect(page).to_not have_content("$99.75")
      end
    end

    it 'can only add discounts to same item not multiple items of same seller' do
      visit '/cart'

      within("#cart-item-#{@item1.id}") do
        5.times do click_on "+" end

        expect(page).to have_content("$333.00")
        expect(page).to_not have_content("$266.40")
      end

      within("#cart-item-#{@item2.id}") do
        expect(page).to have_content("$1,332.26")
        expect(page).to_not have_content("$1,121.90")
      end
    end

    it 'can add multiple discounts to many items in cart' do
      visit "/items/#{@item4.id}"
      click_on "Add To Cart"

      visit '/cart'

      within("#cart-item-#{@item4.id}") do
        5.times do click_on "+" end

        expect(page).to have_content("$55.80")
        expect(page).to_not have_content("$60.00")
      end

      within("#cart-item-#{@item1.id}") do
        30.times do click_on "+" end
        expect(page).to have_content("$1,376.40")
        expect(page).to_not have_content("$1,548.45")
      end

      within("#cart-item-#{@item2.id}") do
        1.times do click_on "+" end
        expect(page).to have_content("$1,395.70")
      end
    end
end
