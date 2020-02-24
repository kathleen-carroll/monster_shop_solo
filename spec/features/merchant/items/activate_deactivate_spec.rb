require 'rails_helper'

RSpec.describe "As a merchant employee" do
  it "can see all my items with info and deactivate the item" do
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

    visit "/merchants/#{merchant2.id}/items"

    expect(item2.active?).to eq(true)
    within "#item-#{item3.id}" do
      expect(page).to_not have_link("deactivate")
    end
  end

  it "can activate item" do
    merchant = create(:random_merchant)
    merchant2 = create(:random_merchant)
    user = create(:merchant_user, merchant: merchant)
    item1 = create(:random_item, active?: false, merchant: merchant)
    item2 = create(:random_item, merchant: merchant)
    item3 = create(:random_item, merchant: merchant2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/merchants/#{merchant.id}/items"

    within "#item-#{item1.id}" do
      expect(page).to have_content(item1.name)
      expect(page).to have_content(item1.description)
      expect(page).to have_content(item1.price)
      expect(page).to have_css("img[src*='#{item1.image}']")
      expect(page).to have_content("Inactive")
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
      click_on "activate"
    end

    item1.reload

    expect(current_path).to eq("/merchants/#{merchant.id}/items")
    expect(page).to have_content("#{item1.name} is now available for sale.")
    expect(item1.active?).to eq(true)

    visit "/merchants/#{merchant2.id}/items"

    within "#item-#{item3.id}" do
      expect(page).to_not have_link("activate")
    end
  end
end
