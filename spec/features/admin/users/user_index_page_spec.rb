require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  describe 'I can click the Users link in the nav' do
    before :each do
      user = create(:admin_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      user1 = create(:regular_user)
      user2 = create(:regular_user)
      user3 = create(:regular_user)
      user3.update(role: 1)
      user4 = create(:regular_user)
      user4.update(role: 1)
      user5 = create(:regular_user)
      user5.update(role: 2)
    end

    it 'I see all the users in the system and their details' do
      visit '/admin'

      within('nav') do
        expect(page).to have_link('Users')
        click_link 'Users'
        expect(current_path).to eq('/admin/users')
      end

      visit '/admin/users'

      expect(page).to have_content()
    end
  end
end

# User Story 53, Admin User Index Page

# As an admin user
# When I click the "Users" link in the nav (only visible to admins)
# Then my current URI route is "/admin/users"
# Only admin users can reach this path.
# I see all users in the system
# Each user's name is a link to a show page for that user ("/admin/users/5")
# Next to each user's name is the date they registered
# Next to each user's name I see what type of user they are