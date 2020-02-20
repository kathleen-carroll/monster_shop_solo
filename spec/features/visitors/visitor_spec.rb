require 'rails_helper'

RSpec.describe "As a visitor" do
  it "can not see merchant, admin, profile" do
    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist")

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist")

    visit '/profile'
    expect(page).to have_content("The page you were looking for doesn't exist")
  end
end
