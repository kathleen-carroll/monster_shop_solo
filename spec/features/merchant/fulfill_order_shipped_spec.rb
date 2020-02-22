require 'rails_helper'

RSpec.describe 'As a merchant employee', type: :feature do
  describe 'when all items on an order are fulfilled' do
    it 'the order status changes from pending to shipped' do

      user = create(:merchant_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      item_order = create(:random_item_order)

      binding.pry
    end
  end
end
