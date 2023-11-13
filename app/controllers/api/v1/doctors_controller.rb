# frozen_string_literal: true

class Api::V1::DoctorsController < ApplicationController
  before_action :admin_required, only: [:update, :destroy]
  def index
    render json: doctors
  end

  def show
    @doctor = doctors.find_by(id: params[:id])
    render json: @doctor
  end

  def update
    @doctor = doctors.find_by(id: params[:id])

    @doctor.update!(doctor_params)
    render json: { message: 'Upadated doctors data', doctor: @doctor }
  rescue => e
    render json: { message: 'Couldn\'t update user data' }
  end

  def destroy
    @doctor = doctors.find_by(id: params[:id])
    @doctors_name =  @doctor.name
    @doctor.destroy
    render json: { message: "Doctor #{@doctors_name} was removed from system"}
  rescue => e
    render json: { message: 'Couldn\'t remove data' }
  end

  private

  def doctors
    @doctors = Doctor.all
  end

  def doctor_params
    {
      name: params[:name],
      specialization: params[:specialization],
      # working_days_summary: params[:working_days_summary] # requires more logic to maintain schema
    }
  end
end
