require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  before :each do
    @merchant_user = create(:merchant_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    @merchant = @merchant_user.merchant
    @discount1 = create(:discount, item_count: 20, percent: 5, merchant: @merchant)
    @discount2 = create(:discount, item_count: 40, percent: 10, merchant: @merchant)
  end

  describe "When I visit the 'My Discounts' view I see a link to add a new discount" do
    it "I click the 'Add New Discount' link and am redirected to a form to add a discount" do

      visit merchant_discounts_path(@merchant)

      click_link 'Add New Discount'

      expect(current_path).to eq(new_merchant_discount_path)

      expect(page).to have_content('Add new discount')

      fill_in 'discount[name]', with: ''
      fill_in 'discount[item_count]', with: 60
      fill_in 'discount[percent]', with: 15
      click_button 'Create Discount'

      expect(page).to have_content("Name can't be blank")
      expect(current_path).to eq("/merchant/discounts")

      fill_in 'discount[name]', with: 'Wintery Discount'
      fill_in 'discount[item_count]', with: 60
      fill_in 'discount[percent]', with: 15
      click_button 'Create Discount'

      expect(current_path).to eq(merchant_discounts_path)

      expect(page).to have_content('Discount created.')

      new_discount = Discount.last

      within("#discount-#{new_discount.id}") do
        expect(page).to have_link(new_discount.name)
        expect(page).to have_content("Items required: #{new_discount.item_count}")
        expect(page).to have_content("Discount: %#{new_discount.percent}")
      end
    end
  end
end
