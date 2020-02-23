class Admin::BaseController < ApplicationController
  before_action :require_user
  
  def require_user
    render file: "/public/404" if current_user.nil? || current_admin? == false
  end
end
