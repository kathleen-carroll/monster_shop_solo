require 'rails_helper'

RSpec.describe "as an admin user" do
  it 'can see regular user page and admin info' do
    user = create(:admin_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/admin'

    expect(page).to_not have_link("Cart")
    expect(page).to_not have_content("Cart: ")

    expect(page).to have_link("Admin Dashboard")
    click_on("Admin Dashboard")
    expect(current_path).to eq("/admin")

    visit '/admin'

    expect(page).to have_link("Users")
    click_on("Users")
    expect(current_path).to eq("/admin/users")
  end

  it 'cant see merchant or cart pages' do
    user = create(:admin_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist")

    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist")
  end
end
