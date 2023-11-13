# frozen_string_literal: true

class Api::V1::RegistrationsController < ApplicationController
  def create
    user = User.find_or_create_by!(email: params[:user_email])
    p user
    user.update!(login_token: SecureRandom.urlsafe_base64,
                 login_token_valid_until: Time.now + 60.minutes)

    url = api_v1_sessions_create_url(login_token: user.login_token)

    Api::V1::RegistrationsMailer.send_email(user, url).deliver_later

    render json: { message: 'Follow instruction you got on email to obtain token' }
  end
end
