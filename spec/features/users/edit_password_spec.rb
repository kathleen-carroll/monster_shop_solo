require 'rails_helper'

RSpec.describe 'As a registered user', type: :feature do
  describe 'On my profile page I see a link to edit my password' do
    it 'I can click the link and I am taken to a form to edit my password' do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      expect(page).to have_content('Edit Password')

      click_link 'Edit Password'
      expect(current_path).to eq("/profile/edit_pw")

      expect(page).to have_field(:password)
      expect(page).to have_field(:password_confirmation)

      fill_in :password, with: 'none1'
      fill_in :password_confirmation, with: 'none1'

      click_button 'Update Password'

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Password updated')
    end
  end
end

# User Story 21, User Can Edit their Password

# As a registered user
# When I visit my profile page
# I see a link to edit my password
# When I click on the link to edit my password
# I see a form with fields for a new password, and a new password confirmation
# When I fill in the same password in both fields
# And I submit the form
# Then I am returned to my profile page
# And I see a flash message telling me that my password is updated