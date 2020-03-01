class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Coupon.where(merchant: current_user.merchant)
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def edit
  end
end
