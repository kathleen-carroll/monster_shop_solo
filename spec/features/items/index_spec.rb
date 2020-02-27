require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?: false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "all items images are links to item show page" do
      visit '/items'

      expect(page).to have_link("image-#{@tire.id}")
      expect(page).to have_link("image-#{@pull_toy.id}")
      click_link("image-#{@pull_toy.id}")
      expect(current_path).to eq("/items/#{@pull_toy.id}")
    end

    it "I can see a list of all of the items "do
      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

    it "I can't see inactive items" do
      inactive_item = create(:random_item, active?: false)
      visit '/items'
      expect(page).to_not have_css("#item-#{inactive_item.id}")
      expect(page).to_not have_css("#item-#{@dog_bone.id}")
    end

    it "I can see popular item statistics" do
      item7 = create(:random_item)
      item6 = create(:random_item)
      item5 = create(:random_item)
      item4 = create(:random_item)
      item3 = create(:random_item)
      item2 = create(:random_item)
      item1 = create(:random_item)

      20.times { create(:random_item_order, item: item1, price: item1.price, quantity: 5) }
      14.times { create(:random_item_order, item: item2, price: item1.price, quantity: 5) }
      11.times { create(:random_item_order, item: item3, price: item1.price, quantity: 5) }
      10.times { create(:random_item_order, item: item4, price: item1.price, quantity: 5) }
      8.times { create(:random_item_order, item: item5, price: item1.price, quantity: 5) }
      3.times { create(:random_item_order, item: item6, price: item1.price, quantity: 5) }
      1.times { create(:random_item_order, item: item7, price: item1.price, quantity: 5) }

      visit '/items'

      within("#statistics") do
        within("#top-1") { expect(page).to have_link(item1.name) }
        within("#top-quantity-1") { expect(page).to have_content(item1.quantity_bought) }
        within("#top-2") { expect(page).to have_link(item2.name) }
        within("#top-quantity-2") { expect(page).to have_content(item2.quantity_bought) }
        within("#top-3") { expect(page).to have_link(item3.name) }
        within("#top-quantity-3") { expect(page).to have_content(item3.quantity_bought) }
        within("#top-4") { expect(page).to have_link(item4.name) }
        within("#top-quantity-4") { expect(page).to have_content(item4.quantity_bought) }
        within("#top-5") { expect(page).to have_link(item5.name) }
        within("#top-quantity-5") { expect(page).to have_content(item5.quantity_bought) }

        within("#bottom-1") { expect(page).to have_link(@tire.name) }
        within("#bottom-quantity-1") { expect(page).to have_content(@tire.quantity_bought) }
        within("#bottom-2") { expect(page).to have_link(@pull_toy.name) }
        within("#bottom-quantity-2") { expect(page).to have_content(@pull_toy.quantity_bought) }
        within("#bottom-3") { expect(page).to have_link(item7.name) }
        within("#bottom-quantity-3") { expect(page).to have_content(item7.quantity_bought) }
        within("#bottom-4") { expect(page).to have_link(item6.name) }
        within("#bottom-quantity-4") { expect(page).to have_content(item6.quantity_bought) }
        within("#bottom-5") { expect(page).to have_link(item5.name) }
        within("#bottom-quantity-5") { expect(page).to have_content(item5.quantity_bought) }
      end
    end
  end
end
