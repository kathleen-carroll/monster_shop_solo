class Merchant::ItemsController < ApplicationController

  def update
    item = Item.find(params[:id])
    merchant = item.merchant 
    item.toggle!(:active?)
    redirect_to "/merchants/#{merchant.id}/items"
    if item.active?
      flash[:success] = "#{item.name} is now avalible for sale."
    else
      flash[:success] = "#{item.name} is no longer for sale."
    end
  end
end