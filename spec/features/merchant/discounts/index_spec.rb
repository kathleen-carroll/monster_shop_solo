require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  before :each do
    @merchant_user = create(:merchant_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    @merchant = @merchant_user.merchant
    @discount1 = create(:discount, item_count: 20, percent: 5, merchant: @merchant)
    @discount2 = create(:discount, item_count: 40, percent: 10, merchant: @merchant)
  end

  describe 'When I visit my merchant dashboard' do
    it "I can click a link to 'My Discounts' to view the discounts index page" do
      visit '/merchant'

      click_link 'My Discounts'

      expect(current_path).to eq(merchant_discounts_path)

      within("#discount-#{@discount1.id}") do
        expect(page).to have_link(@discount1.name)
        expect(page).to have_content("Items required: #{@discount1.item_count}")
        expect(page).to have_content("Discount: #{@discount1.percent}%")
      end

      within("#discount-#{@discount2.id}") do
        expect(page).to have_link(@discount2.name)
        expect(page).to have_content("Items required: #{@discount2.item_count}")
        expect(page).to have_content("Discount: #{@discount2.percent}%")
      end
    end
  end
end
