require 'rails_helper'

RSpec.describe "As a merchant employee" do
  it "I can see all of my items and their info" do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    user = create(:merchant_user, merchant: merchant)
    item1 = create(:random_item, merchant: merchant)
    item2 = create(:random_item, merchant: merchant)
    item3 = create(:random_item, merchant: merchant2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/merchant/items"

    within("#item-#{item1.id}") do
      expect(page).to have_content(item1.name)
      expect(page).to have_content(item1.description)
      expect(page).to have_content(item1.price)
      expect(page).to have_css("img[src*='#{item1.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content(item1.inventory)
    end

    within("#item-#{item2.id}") do
      expect(page).to have_content(item2.name)
      expect(page).to have_content(item2.description)
      expect(page).to have_content(item2.price)
      expect(page).to have_css("img[src*='#{item2.image}']")
      expect(page).to have_content("Active")
      expect(page).to have_content(item2.inventory)
    end

    expect(page).to_not have_css("#item-#{item3.id}")
  end

  it "I can see inactive items" do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    user = create(:merchant_user, merchant: merchant)
    item1 = create(:random_item, merchant: merchant)
    item2 = create(:random_item, merchant: merchant, active?: false)
    item3 = create(:random_item, merchant: merchant2)
    item4 = create(:random_item, merchant: merchant2, active?: false)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/merchant/items"

    expect(page).to have_css("#item-#{item1.id}")
    within("#item-#{item2.id}") { expect(page).to have_content("Inactive")}

    expect(page).to_not have_css("#item-#{item3.id}")
    expect(page).to_not have_css("#item-#{item4.id}")
  end
end
