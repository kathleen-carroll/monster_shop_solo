require 'rails_helper'

RSpec.describe 'As a registered user', type: :feature do
  describe 'When I visit my profile page and click edit profile' do
    it 'I see a form like the registration page pre-populated with my user data' do

      user = create(:regular_user)
      user2 = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'
      click_link 'Edit Profile'
      expect(current_path).to eq(profile_edit_path)

      within("div.userInfo") do
        expect(find_field(:name).value).to eq(user.name)
      end

      within("div.userInfo") do
        expect(find_field(:address).value).to eq(user.address)
      end

      within("div.userInfo") do
        expect(find_field(:city).value).to eq(user.city)
      end

      within("div.userInfo") do
        expect(find_field(:state).value).to eq(user.state)
      end

      within("div.userInfo") do
        expect(find_field(:zip).value).to eq(user.zip)
      end

      within("div.userInfo") do
        expect(find_field(:email).value).to eq(user.email)
      end

      within("div.userInfo") do
        expect(page).to_not have_content(user.password)
      end

      within("div.userInfo") do
        fill_in 'name', with: 'Bill Williams'
      end

      within("div.userInfo") do
        fill_in 'state', with: 'Maine'
      end

      click_button 'Update Profile'

      expect(page).to have_content('Profile successfully updated')
      expect(current_path).to eq('/profile')

      within("div.userInfo") do
        expect(page).to have_content('Bill Williams')
      end

      within("div.userInfo") do
        expect(page).to have_content('Maine')
      end

      click_link 'Edit Profile'

      within("div.userInfo") do
        fill_in 'name', with: ''
      end

      within("div.userInfo") do
        fill_in 'state', with: 'Maine'
      end

      click_button 'Update Profile'

      expect(page).to have_content("Name can't be blank")
      expect(current_path).to eq(profile_edit_path)

      visit '/profile'
      click_link 'Edit Profile'

      within("div.userInfo") do
        fill_in 'email', with: "#{user2.email}"
      end

      click_button 'Update Profile'

      expect(page).to have_content('Email has already been taken')
    end
  end
end
