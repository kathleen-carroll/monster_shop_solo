class CartController < ApplicationController
  before_action :exclude_admin

  def add_item
    item = Item.find(params[:item_id])
    if item.active?
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

  def edit_quantity
    item = Item.find(params[:item_id].to_i)
    if params[:value] == "add"
      cart.contents[item.id.to_s] += 1 if item.inventory != cart.contents[item.id.to_s]
    elsif params[:value] == "sub"
      cart.contents[item.id.to_s] -= 1
      return remove_item if cart.contents[item.id.to_s] == 0
    end
    redirect_to '/cart'
  end

  private

  def exclude_admin
    render file: "/public/404" if current_admin?
  end
end
