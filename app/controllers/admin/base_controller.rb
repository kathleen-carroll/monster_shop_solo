# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :require_user

  def require_user
    render file: '/public/404' if current_admin? == false
  end
end
