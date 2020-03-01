require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  before :each do
    @merchant_user = create(:merchant_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    @merchant = @merchant_user.merchant
    @discount1 = create(:discount, item_count: 20, percent: 5, merchant: @merchant)
    @discount2 = create(:discount, item_count: 40, percent: 10, merchant: @merchant)
  end

  describe "When I visit a discount's showpage and click the 'Edit' link" do
    it 'I can edit and update the discount' do
      visit merchant_discount_path(@discount1)

      click_link 'Edit'

      expect(current_path).to eq(edit_merchant_discount_path(@discount1))

      expect(page).to have_field('discount[name]', with: "#{@discount1.name}")
      expect(page).to have_field('discount[item_count]', with: "#{@discount1.item_count}")

      fill_in 'discount[name]', with: ''
      fill_in 'discount[item_count]', with: 35
      expect(page).to have_field('discount[percent]', with: "#{@discount1.percent}")

      click_button 'Update Discount'

      expect(page).to have_content("Name can't be blank")
      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}")

      fill_in 'discount[name]', with: 'Very Special'
      fill_in 'discount[item_count]', with: 35
      expect(page).to have_field('discount[percent]', with: "#{@discount1.percent}")

      click_button 'Update Discount'

      expect(current_path).to eq(merchant_discount_path(@discount1))

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content("Very Special")
        expect(page).to have_content("Items required: 35")
        expect(page).to have_content("Discount: %5")
      end
    end
  end
end
