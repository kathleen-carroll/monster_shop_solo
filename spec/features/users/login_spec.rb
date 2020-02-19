require 'rails_helper'

RSpec.describe "As a visitor", type: :feature do
  it "can login with valid username and password" do

    regular_user = create(:random_user, email: "ray@gmail.com", password: "password123")

    visit '/'
    click_on 'Log In'

    expect(current_path).to eq("/login")

    fill_in :email, with: "ray@gmail.com"
    fill_in :password, with: "password123"
    click_button "Log In"

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Welcome ray@gmail.com")
  end
end
