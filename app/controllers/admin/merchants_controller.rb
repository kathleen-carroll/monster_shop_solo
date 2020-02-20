class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def toggle_active
    merchant = Merchant.find(params[:merchant_id])
    merchant.toggle!(:active)
    if !merchant.active?
      flash[:notice] = "#{merchant.name} has been deactivated."
    else
      flash[:notice] = "#{merchant.name} has been activated."
    end
    redirect_to admin_merchants_path
  end
end
