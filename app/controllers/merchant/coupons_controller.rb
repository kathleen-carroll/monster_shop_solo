class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Coupon.where(merchant: current_user.merchant)
  end
end
