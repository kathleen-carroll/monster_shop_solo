require 'rails_helper'

RSpec.describe 'As a registered user', type: :feature do
  describe 'On my profile page I see a link to edit my password' do
    it 'I can click the link and I am taken to a form to edit my password' do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      expect(page).to have_content('Edit Password')

      click_link 'Edit Password'
      expect(current_path).to eq(profile_edit_pw_path)

      expect(page).to have_field(:password)
      expect(page).to have_field(:password_confirmation)

      fill_in :password, with: 'none1'
      fill_in :password_confirmation, with: 'none1'

      click_button 'Update Password'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Password updated')

      click_link 'Edit Password'

      fill_in :password, with: 'none1'
      fill_in :password_confirmation, with: 'none5'

      click_button 'Update Password'

      expect(current_path).to eq("/profile/edit/pw")
      expect(page).to have_content("Password confirmation doesn't match Password")

      fill_in :password, with: ''
      fill_in :password_confirmation, with: 'none5'

      click_button 'Update Password'

      expect(current_path).to eq("/profile/edit/pw")
      expect(page).to have_content("Password can't be blank")

      fill_in :password, with: 'none5'
      fill_in :password_confirmation, with: ''

      click_button 'Update Password'

      expect(current_path).to eq("/profile/edit/pw")
      expect(page).to have_content("Password can't be blank")
    end
  end
end
