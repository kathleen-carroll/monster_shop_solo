class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, uniqueness: true, presence: true, case_sensitive: false
  validates :password_digest, confirmation: true
  enum role: %w(regular merchant admin)

  has_many :orders

  has_secure_password
end
