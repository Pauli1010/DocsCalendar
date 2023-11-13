# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
  before_action :require_login, only: :destroy

  def create
    user = User.where(login_token: params[:login_token])
               .where('login_token_valid_until > ?', Time.now).first

    if user
      user.update!(login_token: nil, login_token_valid_until: 1.year.ago)
      auto_login(user)
      render json: { message: 'Authentication completed. Continue with current session' }
    else
      render json: { message: 'Invalid or expired login link' }
    end
  end

  def destroy
    logout
    render json: { message: 'Session invalidated successfully' }
  end
end
