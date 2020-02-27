require 'rails_helper'

RSpec.describe 'item show page', type: :feature do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
  end
  
  it 'shows item info' do
    visit "items/#{@chain.id}"

    expect(page).to have_link(@chain.merchant.name)
    expect(page).to have_link(@chain.name)
    expect(page).to have_content(@chain.description)
    expect(page).to have_content("Price: $#{@chain.price}")
    expect(page).to have_content("Active")
    expect(page).to have_content("Inventory: #{@chain.inventory}")
    expect(page).to have_link(@bike_shop.name)
    expect(page).to have_css("img[src*='#{@chain.image}']")
  end

  it 'has a list of reviews' do
    review_1 = @chain.reviews.create(title: "Great place!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 5)
    review_2 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but not a good selection of things", rating: 3)

    visit "items/#{@chain.id}"

    within "#review-#{review_1.id}" do
      expect(page).to have_content(review_1.title)
      expect(page).to have_content(review_1.content)
      expect(page).to have_content("Rating: #{review_1.rating}/5")
    end

    within "#review-#{review_2.id}" do
      expect(page).to have_content(review_2.title)
      expect(page).to have_content(review_2.content)
      expect(page).to have_content("Rating: #{review_2.rating}/5")
    end
  end

  it 'shows nothing about reviews if there are no reviews' do
    visit "/items/#{@chain.id}"

    within ".review-stats" do
      expect(page).to have_content("This item has not yet been reviewed.")
      expect(page).to_not have_content("Top 3 Reviews")
      expect(page).to_not have_content("Bottom 3 Reviews")
      expect(page).to_not have_content("All Reviews")
    end
  end

  it "can't see deactivated item as visitor" do
    defective_tire = @bike_shop.items.create(name: "Cheapo Tire", description: "Not worth!", price: 5, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 50, active?: false)
    visit "/items/#{defective_tire.id}"

    expect(page).to_not have_content(defective_tire.name)
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  it "can't see deactivated item as regular user" do
    defective_tire = @bike_shop.items.create(name: "Cheapo Tire", description: "Not worth!", price: 5, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 50, active?: false)
    visit "/items/#{defective_tire.id}"

    user = create(:regular_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/items/#{defective_tire.id}"

    expect(page).to_not have_content(defective_tire.name)
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  it "can't see deactivated item as other merchant employee" do
    defective_tire = @bike_shop.items.create(name: "Cheapo Tire", description: "Not worth!", price: 5, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 50, active?: false)
    visit "/items/#{defective_tire.id}"

    user = create(:merchant_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/items/#{defective_tire.id}"

    expect(page).to_not have_content(defective_tire.name)
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  it "can see deactivated item as an administrator" do
    defective_tire = @bike_shop.items.create(name: "Cheapo Tire", description: "Not worth!", price: 5, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 50, active?: false)
    visit "/items/#{defective_tire.id}"

    user = create(:admin_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/items/#{defective_tire.id}"

    expect(page).to have_content(defective_tire.name)
    expect(page).to_not have_content("The page you were looking for doesn't exist.")
  end
end
