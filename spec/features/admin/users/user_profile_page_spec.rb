require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  describe "When I visit a user's profile page" do
    before :each do
      user = create(:admin_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      @user1 = create(:regular_user)
      @user2 = create(:merchant_user)
    end

    it 'I see the same data they would see, but no profile edit link' do
      visit admin_user_path(@user1)

      expect(page).to have_content(@user1.name)
      expect(page).to have_content(@user1.address)
      expect(page).to have_content(@user1.city)
      expect(page).to have_content(@user1.state)
      expect(page).to have_content(@user1.zip)
      expect(page).to have_content(@user1.email)
      expect(page).to have_content(@user1.role)
      expect(page).to_not have_link('Edit Profile')

      visit admin_user_path(@user2)

      expect(page).to have_content(@user2.name)
      expect(page).to have_content(@user2.address)
      expect(page).to have_content(@user2.city)
      expect(page).to have_content(@user2.state)
      expect(page).to have_content(@user2.zip)
      expect(page).to have_content(@user2.email)
      expect(page).to have_content(@user2.role)
      expect(page).to_not have_link('Edit Profile')
    end
  end
end
