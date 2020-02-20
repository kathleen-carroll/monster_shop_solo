require 'rails_helper'

RSpec.describe 'As a registered user', type: :feature do
  describe 'When I visit my profile page' do
    it 'I see all my profile data on the page except my password' do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/profile'

      expect(page).to have_content(user.name)
      expect(page).to have_content(user.address)
      expect(page).to have_content(user.city)
      expect(page).to have_content(user.state)
      expect(page).to have_content(user.zip)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.role)
      expect(page).to_not have_content(user.password)
      expect(page).to have_link('Edit Profile')
    end
  end
end

# User Story 19, User Profile Show Page

# As a registered user
# When I visit my profile page
# Then I see all of my profile data on the page except my password
# And I see a link to edit my profile data