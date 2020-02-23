require 'rails_helper'

RSpec.describe "as a merchant employee user" do
  it 'can see regular user page and merchant info' do
    user = create(:merchant_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/merchant'

    expect(page).to have_link("Cart")
    expect(page).to have_content("Cart: ")

    expect(page).to_not have_link("Admin Dashboard")
    expect(page).to_not have_link("Users")

    expect(page).to have_link("Merchant Dashboard")
    click_on "Merchant Dashboard"
    expect(current_path).to eq("/merchant")
  end

  it 'cant see admin pages' do
    user = create(:merchant_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist")
  end

  it 'can see what merchant works for' do
    user = create(:merchant_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/merchant'

    expect(page).to have_content("Employer: #{user.merchant.name}")
    expect(page).to have_content("Employer Address: #{user.merchant.address} #{user.merchant.city}, #{user.merchant.state} #{user.merchant.zip}")
  end
end
