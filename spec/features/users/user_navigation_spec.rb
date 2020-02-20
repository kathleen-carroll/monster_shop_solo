require 'rails_helper'

RSpec.describe 'As a regular user', type: :feature do
  describe 'I see the same links as a visitor' do
    it 'plus a link to my profile page and a link to logout' do
      user = create(:regular_user)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/'

      within 'nav' do
        expect(page).to have_link('Home')
      end

      within 'nav' do
        expect(page).to have_link('Items')
      end

      within 'nav' do
        expect(page).to have_link('All Merchants')
      end

      within 'nav' do
        expect(page).to have_link('Logout')
      end

      within 'nav' do
        expect(page).to have_link('Profile')
      end

      within 'nav' do
        expect(page).to_not have_link('Register')
      end

      within 'nav' do
        expect(page).to have_content("Logged in as: #{user.name}")
      end
    end
  end
end

# User Story 3, User Navigation

# As a default user
# I see the same links as a visitor
# Plus the following links
# - a link to my profile page ("/profile")
# - a link to log out ("/logout")

# Minus the following links
# - I do not see a link to log in or register

# I also see text that says "Logged in as Mike Dao" (or whatever my name is)