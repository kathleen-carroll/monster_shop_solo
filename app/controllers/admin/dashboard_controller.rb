# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  before_action :require_admin

  def index
    @orders = Order.all
  end

  private

  def require_admin
    render file: '/public/404' unless current_admin?
  end
end
