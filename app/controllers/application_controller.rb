class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart,
                :current_user,
                :current_admin?,
                :current_merchant?,
                :current_merchant_employee?,
                :current_merchant_employee_for_item?

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def error_message(resource)
    flash[:error] = resource.errors.full_messages.to_sentence
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_merchant?
    current_user && current_user.merchant?
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def current_merchant_employee_for_item?
    @item.merchant && (current_merchant? && current_user.merchant_id == @item.merchant.id)
  end
end
