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

    it 'can delete discount from show page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/merchant/discounts/#{@discount.id}"

      click_on 'Remove Discount'

      expect(current_path).to eq("/merchant/discounts")
      expect(page).to have_content("'#{@discount.name}' has been deleted.")

      within ".discounts" do
        expect(page).to_not have_content("#{@discount.name}")
        expect(page).to have_content("#{@discount2.name}")
      end
    end
end
