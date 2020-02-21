require 'rails_helper'

RSpec.describe 'As a visitor in my cart' do
  it 'says need to login or register to checkout' do
    item1 = create(:random_item, inventory: 4)

    visit "/items/#{item1.id}"
    click_on "Add To Cart"

    visit '/cart'

    expect(page).to have_link("Register")
    expect(page).to have_link("Log In")
    expect(page).to have_content("Please register or log in to checkout.")
    expect(page).to_not have_link("Checkout")

    user = create(:regular_user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/cart'
    expect(page).to_not have_content("Please register or log in to checkout.")
    expect(page).to have_link("Checkout")
  end
end
