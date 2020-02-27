require 'rails_helper'

RSpec.describe 'As a merchant' do
  it "can click on coupons" do
    user = create(:merchant_user)
    coupon1 = Coupon.create(name: "Spring Sale", code: "XC569K", percent_off: "20", merchant: user.merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/merchant'
    click_on "Manage Coupons"
    expect(current_path).to eq("/merchant/:merchant_id/coupons")
    expect(page).to have_content("Coupon##{coupon1.id}")
    expect(page).to have_content("#{coupon1.name}")

    click_on "#{coupon1.id}"
    expect(current_path).to eq("merchant/#{user.merchant.id}/coupons/#{coupon1.id}")
  end
end
