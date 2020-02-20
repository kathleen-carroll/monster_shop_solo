require 'rails_helper'
RSpec.describe "on the admin merchant index" do
  it "shows a button to enable or disable merchant" do
    user = create(:admin_user)
    merchant = create(:random_merchant)
    
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/admin/merchants"

    within "#merchant-#{merchant.id}" do
      expect(page).to have_button("Disable")
      expect(page).not_to have_button("Enable")
      click_on "Disable"
    end
    expect(page).to have_content("#{merchant.name} has been deactivated.")
    
    expect(current_path).to eq("/admin/merchants")

    within "#merchant-#{merchant.id}" do
      expect(page).not_to have_button("Disable")
      expect(page).to have_button("Enable")
      click_on "Enable"
    end
    expect(page).to have_content("#{merchant.name} has been activated.")
  end
end
