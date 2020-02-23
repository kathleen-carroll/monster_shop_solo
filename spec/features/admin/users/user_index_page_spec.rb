require 'rails_helper'

RSpec.describe 'As an admin', type: :feature do
  describe 'I can click the Users link in the nav' do
    before :each do
      user = create(:admin_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      @user1 = create(:regular_user)
      @user2 = create(:regular_user)
      @user3 = create(:regular_user)
      @user3.update(role: 1)
      @user4 = create(:regular_user)
      @user4.update(role: 1)
      @user5 = create(:regular_user)
      @user5.update(role: 2)
    end

    it 'I see all the users in the system and their details' do
      visit '/admin'

      within('nav') do
        expect(page).to have_link('Users')
        click_link 'Users'
        expect(current_path).to eq('/admin/users')
      end

      visit '/admin/users'

      within("section#user_#{@user1.id}") do
        expect(page).to have_link(@user1.name)
        expect(page).to have_content(@user1.created_at.to_formatted_s(:long))
        expect(page).to have_content(@user1.role.to_s)
      end

      within("section#user_#{@user2.id}") do
        expect(page).to have_link(@user2.name)
        expect(page).to have_content(@user2.created_at.to_formatted_s(:long))
        expect(page).to have_content(@user2.role.to_s)
      end

      within("section#user_#{@user3.id}") do
        expect(page).to have_link(@user3.name)
        expect(page).to have_content(@user3.created_at.to_formatted_s(:long))
        expect(page).to have_content(@user3.role.to_s)
      end

      within("section#user_#{@user4.id}") do
        expect(page).to have_link(@user4.name)
        expect(page).to have_content(@user4.created_at.to_formatted_s(:long))
        expect(page).to have_content(@user4.role.to_s)
      end

      within("section#user_#{@user5.id}") do
        expect(page).to have_link(@user5.name)
        expect(page).to have_content(@user5.created_at.to_formatted_s(:long))
        expect(page).to have_content(@user5.role.to_s)
      end
    end
  end
end
