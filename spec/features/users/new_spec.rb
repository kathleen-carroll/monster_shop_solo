require 'rails_helper'

RSpec.describe "user creation" do
  it "creates a new user" do
    visit "/"

    click_on "Register"

    expect(current_path).to eq("/register")

    fill_in :name, with: "John Bill"
    fill_in :address, with: "1491 Street St"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "801231"
    fill_in :email, with: "john@mail.com"
    fill_in :password, with: "burgers"
    fill_in :password_confirmation, with: "burgers"

    click_button "Submit"
    new_user = User.last

    expect(new_user.regular?).to eq(true)
    expect(current_path).to eq("/profile")
    expect(page).to have_content("New account successfully created! You are now logged in.")
  end

  it "flashes error when fields are missing" do
    visit "/"

    click_on "Register"

    expect(current_path).to eq("/register")

    fill_in :address, with: "1491 Street St"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "801231"
    fill_in :email, with: "john@mail.com"
    fill_in :password, with: "burgers"
    fill_in :password_confirmation, with: "burgers"

    click_button "Submit"

    expect(page).to have_content("Name can't be blank")
  end

  it "prepopulates previous data when failing creation" do
    visit "/"

    click_on "Register"

    expect(current_path).to eq("/register")

    fill_in :address, with: "1491 Street St"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "801231"
    fill_in :email, with: "john@mail.com"
    fill_in :password, with: "burgers"
    fill_in :password_confirmation, with: "burgers"

    click_button "Submit"

    expect(page).to have_content("Name can't be blank")

    find_field :address, with: "1491 Street St"
    find_field :city, with: "Denver"
    find_field :state, with: "CO"
    find_field :zip, with: "801231"
  end

  it "displays flash message for same email already existing" do
    create(:regular_user, email: "john@mail.com")

    visit "/"

    click_on "Register"

    expect(current_path).to eq("/register")

    fill_in :name, with: "John Bill"
    fill_in :address, with: "1491 Street St"
    fill_in :city, with: "Denver"
    fill_in :state, with: "CO"
    fill_in :zip, with: "801231"
    fill_in :email, with: "john@mail.com"
    fill_in :password, with: "burgers"
    fill_in :password_confirmation, with: "burgers"

    click_button "Submit"

    expect(page).to have_content("Email has already been taken")
  end
end
