require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do
  it "can login with valid username and password as regular user" do

    regular_user = create(:regular_user, email: "ray@gmail.com", password: "password123")

    visit '/'
    click_on 'Log In'

    expect(current_path).to eq("/login")

    fill_in :email, with: "ray@gmail.com"
    fill_in :password, with: "password123"
    click_button "Submit"

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Welcome #{regular_user.name}")
    expect(page).to have_link("Log Out")
    expect(page).to_not have_link("Register as a User")
    expect(page).to_not have_link("I already have an account")
  end

  it "cannot log in with bad credentials" do

    regular_user = create(:regular_user, email: "ray@gmail.com", password: "password123")

    visit "/"

    click_on "Log In"

    fill_in :email, with: "ray@gmail.com"
    fill_in :password, with: "incorrect password"

    click_on "Submit"

    expect(current_path).to eq('/login')
    expect(page).to have_content("Sorry, your credentials are bad.")
  end

  it "can log out" do
    regular_user = create(:regular_user, email: "ray@gmail.com", password: "password123")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user)

    visit "/profile"

    expect(regular_user.email).to eq("ray@gmail.com")
    expect(current_path).to eq('/profile')

    click_link("Log Out")
    expect(current_path).to eq('/')
    expect(page).to have_content("You are now logged out.")
  end

  it "when I log in as a merchant user I am redirected to my merchant dashboard" do

    merchant_user = create(:merchant_user, role: 1)

    visit '/merchants'
    click_on 'Log In'

    expect(current_path).to eq("/login")

    fill_in :email, with: merchant_user.email
    fill_in :password, with: merchant_user.password

    click_button "Submit"

    expect(current_path).to eq('/merchant')
    expect(page).to have_content("Welcome Merchant #{merchant_user.name}")
    click_on "Log Out"

    visit '/merchant'
    click_on 'Log In'

    expect(current_path).to eq("/login")

    fill_in :email, with: merchant_user.email
    fill_in :password, with: merchant_user.password

    click_button "Submit"

    expect(current_path).to eq('/merchant')
    expect(page).to have_content("Welcome Merchant #{merchant_user.name}")

    end

    it "when I am an admin user I am redirected to my admin dashboard page" do
      admin_user = create(:admin_user, role: 2)

      visit '/merchants'
      click_on 'Log In'

      expect(current_path).to eq("/login")

      fill_in :email, with: admin_user.email
      fill_in :password, with: admin_user.password

      click_button "Submit"

      expect(current_path).to eq('/admin')
      expect(page).to have_content("Welcome Admin #{admin_user.name}!")
    end


  it "redirects to approprate path when login as a regular user" do
    regular_user = create(:regular_user, email: "ray@gmail.com", password: "password123")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(regular_user)

    visit "/login"

    expect(current_path).to eq("/profile")
    expect(page).to have_content("You are already logged in as user.")
  end

  it "redirects to approprate path when login as a admin user" do
    user = create(:admin_user, email: "ray@gmail.com", password: "password123")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/login"

    expect(current_path).to eq("/admin")
    expect(page).to have_content("You are already logged in as admin.")
  end

  it "redirects to approprate path when login as a merchant user" do
    user = create(:merchant_user, email: "ray@gmail.com", password: "password123")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/login"

    expect(current_path).to eq("/merchant")
    expect(page).to have_content("You are already logged in as merchant.")
  end

  it "deletes cart when regular user logs out" do
    user = create(:regular_user, email: "ray@gmail.com", password: "password123")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    expect(page).to have_content("Cart: 3")

    click_on 'Log Out'
    expect(page).to have_content("Cart: 0")
  end

  it "deletes cart when merchant user logs out" do
    user = create(:merchant_user, email: "ray@gmail.com", password: "password123")
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
    @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    visit "/items/#{@paper.id}"
    click_on "Add To Cart"
    visit "/items/#{@tire.id}"
    click_on "Add To Cart"
    visit "/items/#{@pencil.id}"
    click_on "Add To Cart"

    expect(page).to have_content("Cart: 3")

    click_on 'Log Out'
    expect(page).to have_content("Cart: 0")
  end
end
