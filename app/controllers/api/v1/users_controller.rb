# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :require_login
  before_action :admin_required, only: [:index, :show, :update]

  def index
    render json: users
  end

  def show
    @user = users.find_by(id: params[:id])
    render json: @user
  end

  def update
    @user = users.find_by(id: params[:id])

    @user.update!(name: params[:name], admin: params[:admin])
    render json: { message: 'Upadated user data', user: @user }
  rescue => e
    render json: { message: 'Couldn\'t update user data' }
  end

  def my_data
    render json: current_user
  end

  def update_my_data
    current_user.update!(name: params[:name])
    render json: { message: 'Upadated user data', user: current_user }
  rescue => e
    render json: { message: 'Couldn\'t update user data' }
  end

  private

  def users
    @users = User.all
  end
end
