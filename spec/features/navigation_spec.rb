require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')

      within 'nav' do
        click_link 'Login'
      end

      expect(current_path).to eq('/login')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register')

      within 'nav' do
        click_link 'Login'
      end

      expect(current_path).to eq('/login')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end
  end
end

# User Story 2, Visitor Navigation

# As a visitor
# I see a navigation bar
# This navigation bar includes links for the following:
# - a link to return to the welcome / home page of the application ("/")
# - a link to browse all items for sale ("/items")
# - a link to see all merchants ("/merchants")
# - a link to my shopping cart ("/cart")
# - a link to log in ("/login")
# - a link to the user registration page ("/register")

# Next to the shopping cart link I see a count of the items in my cart