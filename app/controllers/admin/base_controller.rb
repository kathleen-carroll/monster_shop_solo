# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :require_user

  private

  def require_user
    render file: '/public/404' unless current_admin?
  end
end
