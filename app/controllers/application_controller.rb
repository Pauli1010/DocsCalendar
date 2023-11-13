# frozen_string_literal: true

class ApplicationController < ActionController::API
  def user_class
    User
  end

  def not_authenticated
    render json: { message: 'You need to authenticate to continue' }
  end

  def admin_required
    return if logged_in? && current_user.admin?

    render json: { message: 'You do not have permission to acces this data' }
  end
end
