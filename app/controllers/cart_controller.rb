class CartController < ApplicationController
  before_action :exclude_admin

  def add_item
    item = Item.find(params[:item_id])
    if item.active? && !cart.inventory_limit?('max', item)
      cart.add_item(item.id.to_s)
      flash[:success] = "#{item.name} was successfully added to your cart."
      redirect_to "/items"
    else
      flash[:error] = "#{item.name} is no longer available."
      redirect_to "/items"
    end
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def edit
    return remove_item if cart.edit_quantity(params) == 0
    redirect_to '/cart'
  end

  private

  def exclude_admin
    render file: "/public/404" if current_admin?
  end
end
