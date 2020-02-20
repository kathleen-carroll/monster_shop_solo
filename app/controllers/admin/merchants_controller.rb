class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.toggle!(:active?)
    if !merchant.active?
      flash[:notice] = "#{merchant.name} has been deactivated."
    else
      flash[:notice] = "#{merchant.name} has been activated."
    end
    redirect_to admin_merchants_path
  end
end
