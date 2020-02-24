require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do
  describe "when I visit my items page and I see a link to add a new item" do
    before :each do
      @merchant = create(:random_merchant)
      @merchant_employee = create(:merchant_user, merchant: @merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end

    it "can click on that link to add a new item" do
        visit "/merchants/#{@merchant.id}/items"
        click_on "Add New Item"
        expect(current_path).to eq("/merchants/#{@merchant.id}/items/new")

        name = "Chamois Buttr"
        price = 18
        description = "No more chaffin'!"
        image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
        inventory = 25

        fill_in "Name", with: name
        fill_in "Price", with: price
        fill_in "Description", with: description
        fill_in "Image", with: image_url
        fill_in "Inventory", with: inventory

        click_button "Create Item"

        
        new_item = Item.last
        
        expect(page).to have_content("#{new_item.name} has been saved.")
        expect(current_path).to eq("/merchants/#{@merchant.id}/items")
        expect(new_item.name).to eq(name)
        expect(Item.last.active?).to be(true)
        expect(page).to have_content(name)
        expect(page).to have_css("img[src*='#{new_item.image}']")
    end
  end
end
