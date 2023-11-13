# frozen_string_literal: true

class Api::V1::RegistrationsMailer < ApplicationMailer
  def send_email(user, url)
    @user = user
    @url  = url

    mail to: @user.email, subject: 'Obtain your token!'
  end
end