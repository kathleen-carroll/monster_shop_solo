require 'rails_helper'

RSpec.describe "As a merchant employee" do
  it "I can deactivate an item" do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    user = create(:merchant_user, merchant: merchant)
    item1 = create(:random_item, merchant: merchant)
    item2 = create(:random_item, merchant: merchant)
    create(:random_item, merchant: merchant2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/merchant/items"

    within("#item-#{item1.id}") { click_link "Deactivate" }
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{item1.name} is no longer for sale.")
    within("#item-#{item1.id}") { expect(page).to have_content("Inactive") }
    within("#item-#{item2.id}") { expect(page).to have_content("Active") }
  end

  it "I can activate an item" do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    user = create(:merchant_user, merchant: merchant)
    item1 = create(:random_item, active?: false, merchant: merchant)
    create(:random_item, merchant: merchant)
    create(:random_item, merchant: merchant2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/merchant/items"

    within("#item-#{item1.id}") { expect(page).to have_content("Inactive") }

    within("#item-#{item1.id}") { click_on "Activate" }

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{item1.name} is now available for sale.")
    within("#item-#{item1.id}") { expect(page).to have_content("Active") }
  end
end
