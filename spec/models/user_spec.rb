require 'rails_helper'

describe User, type: :model do

  describe "relationships" do
    it {should have_many :orders}
    it {should belong_to(:merchant).optional}
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :email}
    it {should validate_presence_of :address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zip}
    it {should validate_presence_of :password}
    it {should validate_uniqueness_of :email}
    it {should define_enum_for(:role).with_values([:regular, :merchant, :admin])}
  end

  describe 'model methods' do
    it 'pw_check_not_empty? returns false' do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      expect(user.pw_check_not_empty({password: 'none', password_confirmation: ''})).to eq(false)
      expect(user.pw_check_not_empty({password: '', password_confirmation: 'none'})).to eq(false)
      expect(user.pw_check_not_empty({password: 'none', password_confirmation: 'none'})).to eq(true)
    end
  end

  describe 'model methods' do
    it 'pw_check_empty returns true' do
      user = create(:regular_user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      expect(user.pw_check_empty({password: 'none', password_confirmation: ''})).to eq(true)
      expect(user.pw_check_empty({password: '', password_confirmation: 'none'})).to eq(true)
      expect(user.pw_check_empty({password: 'none', password_confirmation: 'none'})).to eq(false)
    end
  end
end
