require 'rails_helper'

RSpec.describe "As a merchant employee" do
  it "can delete the item" do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    user = create(:merchant_user, merchant: merchant)
    item1 = create(:random_item, merchant: merchant)
    create(:random_item, merchant: merchant)
    item3 = create(:random_item, merchant: merchant2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/merchant/items"

    expect(page).to have_css("#item-#{item1.id}")

    within("#item-#{item1.id}") { click_link "Delete" }

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("Item Deleted.")
    expect(page).to_not have_css("#item-#{item1.id}")

    visit "/merchants/#{merchant2.id}/items"

    expect(page).to have_css("#item-#{item3.id}")
  end
end
