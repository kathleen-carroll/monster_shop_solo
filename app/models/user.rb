class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, uniqueness: true, presence: true, case_sensitive: false
  validates :password_digest, confirmation: true
  enum role: %w(regular merchant admin)
  validates :merchant, presence: true, if: :merchant?
  belongs_to :merchant, optional: true

  has_many :orders

  has_secure_password

  def pw_check_not_empty(params)
    !params[:password].empty? && !params[:password_confirmation].empty?
  end

  def pw_check_empty(params)
    params[:password].empty? || params[:password_confirmation].empty?
  end
end
