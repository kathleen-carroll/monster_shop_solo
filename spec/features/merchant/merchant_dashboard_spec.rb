require 'rails_helper'

RSpec.describe "as a merchant employee user" do
  xit 'can see regular user page and merchant info' do
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

  xit 'cant see admin pages' do
    user = create(:merchant_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist")
  end

  xit 'can see what merchant works for' do
    user = create(:merchant_user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/merchant'

    expect(page).to have_content("Employer: #{user.merchant.name}")
    expect(page).to have_content("Employer Address: #{user.merchant.address} #{user.merchant.city}, #{user.merchant.state} #{user.merchant.zip}")
  end

  it 'can see orders that have been place for that merchants products' do
    user = create(:merchant_user)
    item = create(:random_item, merchant: user.merchant)
    item_order = create(:random_item_order, item: item)
    item2 = create(:random_item, merchant: user.merchant)
    item_order2 = create(:random_item_order, item: item)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit '/merchant'

    expect(page).to have_content("Order##{item_order.order_id}")
    expect(page).to have_link("#{item_order.order_id}")
    expect(page).to have_content("Order placed: #{item_order.created_at.to_formatted_s(:long)}")
    expect(page).to have_content("Number of items: #{item_order.quantity}")
    expect(page).to have_content("Total Price: $#{item_order.price}")

    click_on "#{item_order.order_id}"
    expect(current_path).to eq("/merchant/orders/#{item_order.order_id}")

    expect(page).to have_link("#{item_order2.order_id}")
    expect(page).to have_content("Order##{item_order2.order_id}")
    expect(page).to have_content("Order placed: #{item_order2.created_at.to_formatted_s(:long)}")
    expect(page).to have_content("Number of items: #{item_order2.quantity}")
    expect(page).to have_content("Total Price: $#{item_order2.price}")

    click_on "#{item_order2.order_id}"
    expect(current_path).to eq("/merchant/orders/#{item_order2.id}")
  end
end
