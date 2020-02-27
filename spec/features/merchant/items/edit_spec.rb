require 'rails_helper'

RSpec.describe "As a Merchant" do
  describe "When I visit my Item Show Page" do
    describe "and click on edit item" do
      before :each do
        @merchant = create(:random_merchant)
        merchant_employee = create(:merchant_user, merchant: @merchant)
        @item1 = @merchant.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)
      end
      
      it 'I can see the prepopulated fields of that item and update it' do

        visit "/merchant/items"

        click_link "#{@item1.name}"
        expect(current_path).to eq("/merchant/items/#{@item1.id}")

        click_link "Edit"

        expect(current_path).to eq("/merchant/items/#{@item1.id}/edit")
        find_field :name, with: @item1.name
        find_field :price, with: "100.0"
        find_field :description, with: @item1.description

        fill_in :name, with: "special"
        fill_in :price, with: "10"
        fill_in :inventory, with: "10"
        fill_in :description, with: "okay"

        click_button "Update Item"
        expect(current_path).to eq("/merchant/items")

        expect(page).to have_content("special has been updated.")
        expect(page).to have_content("special")
        visit ("/merchant/items")
        expect(page).to_not have_content("Gatorskins")
        expect(page).to have_content("Price: $10")
        expect(page).to have_content("Inventory: 10")
        expect(page).to_not have_content("Inventory: 12")
        expect(page).to_not have_content("Price: $100")
        expect(page).to have_content("okay")
        expect(page).to_not have_content("They'll never pop!")
        expect(@item1.active?).to eq(true)
      end

      it "I can't edit if an item if fields are not filled in" do
        visit "/merchant/items"
        click_link "Edit"

        fill_in 'Name', with: ""
        fill_in 'Price', with: 110
        fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
        fill_in 'Inventory', with: 11
        click_button "Update Item"
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_button("Update Item")
      end

      it "can only enter a number in inventory" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        merchant_employee = create(:merchant_user, merchant: meg)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)


        visit "/merchant/items/#{tire.id}"

        click_on "Edit Item"

        fill_in 'Name', with: "ray"
        fill_in 'Price', with: 110
        fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
        fill_in 'Image', with: "image"
        fill_in 'Inventory', with: "string"

        click_on "Update Item"

        expect(page).to have_content("Inventory is not a number")
      end
    end
  end
end
