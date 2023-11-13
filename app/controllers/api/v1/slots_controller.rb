# frozen_string_literal: true

class Api::V1::SlotsController < ApplicationController
  before_action :require_login, except: :index

  # /api/v1/doctors/:doctor_id/slots?date=
  # /api/v1/open_slots?doctor_id=&date=
  def index
    @slots = open_slots
    @slots = open_slots.by_doctor(params[:doctor_id]) if params[:doctor_id].present?
    @slots = open_slots.by_date(params[:date]) if params[:date].present?

    render json: @slots
  end

  # /api/v1/my_slots
  def my_slots
    @slots = current_user.appointments

    render json: @slots
  end

  # /api/v1/doctors/:doctor_id/slots/:id?user_email=
  # /api/v1/update_slot?doctor_id=&id=&user_email=
  def update
    @slot = Slot.reserved_slots.find_by(id: params[:id], doctor_id: params[:doctor_id])

    if @slot
      @slot.add_message(params[:message]) if current_user == @slot.user
      render json: { message: 'Thank you, additional info was added to your reservation.' }
    else
      render json: { message: 'Something went wrong, make sure you found the proper slot' }
    end
  end

  # /api/v1/doctors/:doctor_id/slots/:id/reserve_slot?user_email=
  # /api/v1/reserve_slot?doctor_id=&id=&user_email=
  def reserve_slot
    @slot = open_slots.find_by(id: params[:id], doctor_id: params[:doctor_id])

    if @slot
      @slot.reserve(current_user)
      render json: { message: 'Thank you, slot was reserved.' }
    else
      render json: { message: 'Something went wrong, make sure slot is open' }
    end
  end

  # /api/v1/doctors/:doctor_id/slots/:id/free_slot?user_email=
  # /api/v1/free_slot?doctor_id=&id=&user_email=
  def free_slot
    @slot = Slot.reserved_slots.find_by(id: params[:id], doctor_id: params[:doctor_id])

    if @slot
      @slot.free_up if current_user == @slot.user
      render json: { message: 'Thank you for registration' }
    else
      render json: { message: 'Something went wrong, make sure you found the proper slot' }
    end
  end

  private

  def open_slots
    @slots = Slot.open_slots
  end
end
