require 'rails_helper'

RSpec.describe "As a merchant employee" do
  it "can see all my items with info" do
    user = create(:merchant_user)
    merchant = create(:random_merchant)
    item1 = create(:random_item, merchant: merchant)
    item2 = create(:random_item, merchant: merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/merchants/#{merchant.id}/items"

    within "#item-#{item1.id}" do
      expect(page).to have_content(item1.name)
      expect(page).to have_content(item1.description)
      expect(page).to have_content(item1.price)
      expect(page).to have_css("img[src*='#{item1.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content(item1.inventory)
    end
    
    within "#item-#{item2.id}" do
      expect(page).to have_content(item2.name)
      expect(page).to have_content(item2.description)
      expect(page).to have_content(item2.price)
      expect(page).to have_css("img[src*='#{item2.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content(item2.inventory)
    end

    within "#item-#{item1.id}" do
      click_on "deactivate"
    end

    item1.reload

    expect(current_path).to eq("/merchants/#{merchant.id}/items")
    expect(page).to have_content("#{item1.name} is no longer for sale.")
    expect(item1.active?).to eq(false)
  end
end




