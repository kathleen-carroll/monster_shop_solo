require 'rails_helper'

RSpec.describe "As a merchant employee" do
  it "can delete the item" do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    user = create(:merchant_user, merchant: merchant)
    item1 = create(:random_item, merchant: merchant)
    item2 = create(:random_item, merchant: merchant)
    item3 = create(:random_item, merchant: merchant2)

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

    within "#item-#{item1.id}" do
      click_on "delete"
    end

    expect(current_path).to eq("/merchants/#{merchant.id}/items")
    expect(page).to have_content("Item Deleted.")
    expect(page).to_not have_content(item1.name)

    visit "/merchants/#{merchant2.id}/items"

    expect(item2.active?).to eq(true)
    within "#item-#{item3.id}" do
      expect(page).to_not have_link("delete")
    end
  end
end
