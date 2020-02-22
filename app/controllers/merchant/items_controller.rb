class Merchant::ItemsController < ApplicationController

  def update
    item = Item.find(params[:id])
    merchant = item.merchant 
    item.toggle!(:active?)
    redirect_to "/merchants/#{merchant.id}/items"
    if item.active?
      flash[:success] = "#{item.name} is now available for sale."
    else
      flash[:success] = "#{item.name} is no longer for sale."
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = "Item Deleted."
    redirect_to "/merchants/#{item.merchant.id}/items"
  end
end
