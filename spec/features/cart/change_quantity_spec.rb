require 'rails_helper'

RSpec.describe 'cart quantity' do
  describe 'from the cart' do
    it 'sees button to increment the item quantity and cant go above inventory' do
      item1 = create(:random_item, inventory: 4)

      visit "/items/#{item1.id}"
      click_on "Add To Cart"

      visit '/cart'

      expect(page).to have_content("#{item1.name}")
      expect(page).to have_content("Quantity")

      within "#qty" do
        expect(page).to have_content("1")
        expect(page).to have_button("+")

        click_on("+")
        expect(page).to have_content("2")
        expect(page).to_not have_content("1")

        2.times do click_on("+") end
        expect(page).to have_content("4")

        click_on("+")
        expect(page).to have_content("4")

        2.times do click_on("+") end
        expect(page).to have_content("4")
      end
    end

    it "sees button to decrement the item quantity and if goes to 0 item is removed from cart" do
      item1 = create(:random_item, inventory: 4)

      visit "/items/#{item1.id}"
      click_on "Add To Cart"

      visit '/cart'

      expect(page).to have_content("#{item1.name}")
      expect(page).to have_content("Quantity")

      within ("#qty") do
        3.times do click_on("+") end
        expect(page).to have_content("4")
        expect(page).to have_button("-")

        click_on("-")
        expect(page).to have_content("3")
        expect(page).to_not have_content("4")

        2.times do click_on("-") end
        expect(page).to have_content("1")

        click_on("-")
      end

      expect(page).to have_content("Cart is currently empty")
    end
  end
end
