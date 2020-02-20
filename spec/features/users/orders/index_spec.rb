require 'rails_helper'

RSpec.describe 'profile orders index page', type: :feature do
  describe 'As a user' do
    before :each do

    end

    it 'I can see a link to my orders' do
      visit '/profile'

      click_link('My Orders')
      expect(current_path).to eq('/profile/orders')
    end
  end
end
