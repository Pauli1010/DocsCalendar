# frozen_string_literal: true

class Api::V1::DoctorsController < ApplicationController
  def index
    render json: doctors
  end

  def show
    @doctor = doctors.find_by(id: params[:id])
    render json: @doctor
  end

  private

  def doctors
    @doctors = Doctor.all
  end
end
