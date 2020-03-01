require 'rails_helper'

RSpec.describe 'As a merchant' do
  before(:each) do
    @user = create(:merchant_user)
    @coupon1 = Coupon.create(name: "Spring Sale", code: "XC569K", percent_off: "20", merchant: @user.merchant)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  xit "can click on coupons" do
    visit '/merchant'
    click_on "Manage Coupons"
    expect(current_path).to eq("/merchant/:merchant_id/coupons")
    expect(page).to have_content("Coupon##{@coupon1.id}")
    expect(page).to have_content("#{@coupon1.name}")

    click_on "#{@coupon1.id}"
    expect(current_path).to eq("/merchant/#{@user.merchant.id}/coupons/#{@coupon1.id}")
  end

  xit "can edit coupons from show page" do
    visit "/merchant/#{@user.merchant.id}/coupons/#{@coupon1.id}"
    click_on 'Edit Coupon'

    expect(current_path).to eq("/merchant/#{@user.merchant.id}/coupons/#{@coupon1.id}/edit")
    expect(find_field(:name).value).to eq(@user.name)
    expect(find_field(:code).value).to eq(@user.code)
    expect(find_field(:percent_off).value).to eq(@user.percent_off)

    fill_in 'percent_off', with: 25

    click_on 'Update Coupon'
    expect(current_path).to eq("/merchant/#{@user.merchant.id}/coupons/#{@coupon1.id}")
  end
end
