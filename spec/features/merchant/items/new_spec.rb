require 'rails_helper'

RSpec.describe "As a merchant", type: :feature do
  describe "when I visit my items page and I see a link to add a new item" do
    before :each do
      @merchant = create(:random_merchant)
      @merchant_employee = create(:merchant_user, merchant: @merchant)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
    end

    it "I can click on that link to add a new item" do
      visit "/merchant/items"
      click_on "Add New Item"
      expect(current_path).to eq("/merchant/#{@merchant.id}/items/new")

      name = "Chamois Buttr"
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"


      new_item = Item.last

      expect(page).to have_content("#{new_item.name} has been saved.")
      expect(current_path).to eq("/merchant/items")
      expect(new_item.name).to eq(name)
      expect(Item.last.active?).to be(true)
      expect(page).to have_content(name)
      expect(page).to have_css("img[src*='#{new_item.image}']")
    end

    it 'I can add a new item without an image' do
      visit "/merchant/items"
      click_on "Add New Item"
      expect(current_path).to eq("/merchant/#{@merchant.id}/items/new")

      name = "slime"
      price = 18
      description = "No more chaffin'!"
      inventory = 25

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :inventory, with: inventory

      click_button "Create Item"

      new_item = Item.last

      expect(page).to have_content("#{new_item.name} has been saved.")
      expect(current_path).to eq("/merchant/items")
      expect(new_item.name).to eq(name)
      expect(Item.last.active?).to be(true)
      expect(page).to have_content(name)
    end

    it 'I can not add an item without filling required fields' do
      visit "/merchant/items"
      click_on "Add New Item"
      expect(current_path).to eq("/merchant/#{@merchant.id}/items/new")

      name = "blinker fluid"
      price = 18.00
      description = "No more chaffin'!"

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: ""

      click_button "Create Item"

      expect(page).to have_content("Inventory can't be blank")
      find_field :name, with: name
      find_field :price, with: price
      find_field :description, with: description
    end
  end
end
